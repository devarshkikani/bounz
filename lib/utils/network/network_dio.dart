import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bounz_revamp_app/config/manager/global_singleton.dart';
import 'package:bounz_revamp_app/config/manager/storage_manager.dart';
import 'package:bounz_revamp_app/constants/app_const_text.dart';
import 'package:bounz_revamp_app/constants/app_storage_key.dart';
import 'package:bounz_revamp_app/main.dart';
import 'package:bounz_revamp_app/modules/hacked_data/hacked_data_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:dio/src/response.dart' as dio;
import 'package:bounz_revamp_app/utils/api_path.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:bounz_revamp_app/config/theme/app_colors.dart';
import 'package:bounz_revamp_app/utils/progress_indicator.dart';
import 'package:bounz_revamp_app/config/theme/app_text_style.dart';
import 'package:bounz_revamp_app/config/routes/router_import.dart';
import 'package:bounz_revamp_app/config/routes/router_import.gr.dart';

// import 'package:dio_http_cache/dio_http_cache.dart';
// ignore_for_file: implementation_imports, avoid_catches_without_on_clauses

class NetworkDio {
  static late Dio _dio;
  static Circle processIndicator = Circle();
  static late Map<String, dynamic> giftVoucherHeader;
  static late Map<String, dynamic> rssHeader;
  static late Map<String, dynamic> appHeader;

  // static late DioCacheManager dioCacheManager;
  // static final Options cacheOptions =
  //     buildCacheOptions(const Duration(seconds: 1), forceRefresh: true);

  static Future<void> setDynamicHeader({
    required String authorizationToken,
  }) async {
    final BaseOptions options =
        BaseOptions(receiveTimeout: 50000, connectTimeout: 50000);
    // dioCacheManager = DioCacheManager(CacheConfig());
    giftVoucherHeader = _getGiftVochuresHeaders(
      authorizationToken: authorizationToken,
    );
    appHeader = _getHeaders(
      authorizationToken: authorizationToken,
    );
    rssHeader = _getRssHeaders(
      authorizationToken: authorizationToken,
    );

    options.headers.addAll(appHeader);
    _dio = Dio(options);
    if (!GlobalSingleton.isProd) {
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        requestHeader: false,
        responseHeader: false,
        responseBody: true,
        error: true,
      ));
    }

    Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult event) async {
      if (ConnectionState.none.name == event.name) {
        AppRouter().push(const NoInternetScreenRoute());
      }
    });
  }

  static Map<String, String> _getRssHeaders({
    required String authorizationToken,
  }) {
    return <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': authorizationToken,
    };
  }

  static Map<String, String> _getHeaders({
    required String authorizationToken,
  }) {
    return <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': authorizationToken, //ApiPath.authorization,
      'TP_APPLICATION_KEY': ApiPath.tpApplicationKey,
      'API_TOKEN': ApiPath.apiTokenPoint
    };
  }

  static Map<String, String> _getGiftVochuresHeaders({
    required String authorizationToken,
  }) {
    return <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': authorizationToken, //ApiPath.authorization,
      'API_KEY': ApiPath.apiKey,
    };
  }

  static Future<bool> check() async {
    final ConnectivityResult connectivityResult =
        await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  static Future<String?> getSha1(context, url) async {
    HttpClient client1 = HttpClient();
    client1.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);

    HttpClientRequest request =
        await client1.getUrl(Uri.parse(GlobalSingleton.sslCheckURL));

    HttpClientResponse response1 = await request.close();
    return response1.certificate?.sha1.toString();
  }

  static void redirectToHackedPage(context) {
    appRouter.pushWidget(const HackedDataScreen());
  }

  static Future<bool> isValidSSLPinning(context, url) async {
    String key = await getSha1(context, url) ?? "";
    return key !=
        (GlobalSingleton.isProd
            ? AppConstString.sha1KeyProd
            : AppConstString.sha1KeyUat);
  }

  // static Future<bool> isValidSSLPinForCheckUpdate(context, url) async {
  //   String key = await getSha1(context, url) ?? "";
  //   return key != AppConstString.sha1KeyCheckUpdates;
  // }

  static Future<Map<String, dynamic>?> postDioHttpMethod({
    BuildContext? context,
    bool? notShowError,
    bool? notShowLoader,
    bool? forceReturn,
    required String url,
    required dynamic data,
  }) async {
    final bool internet = await check();
    if (internet) {
      if (context != null && notShowLoader != true) {
        processIndicator.show(context);
      }
      try {
        if (await isValidSSLPinning(context, url)) {
          redirectToHackedPage(context);
        } else {
          final dio.Response<dynamic> response = await _dio.post(
            url,
            data: data,
            // options: cacheOptions,
          );
          Map<String, dynamic> responseBody = <String, dynamic>{};
          if (context != null && notShowLoader != true) {
            processIndicator.hide(context);
          }

          if (response.statusCode == 200) {
            try {
              responseBody =
                  json.decode(response.data.toString()) as Map<String, dynamic>;
            } catch (e) {
              responseBody = response.data as Map<String, dynamic>;
            }
            if (responseBody['statuscode'] == 200) {
              if (responseBody['data']['status_code'] == "CC00011" ||
                  responseBody['data']['status_code'] == "CC00010") {
                StorageManager.setStringValue(
                  key: AppStorageKey.deletedAccountText,
                  value: responseBody['data']['message'],
                );
                appRouter.pushAndPopUntil(
                    DeletedAccountScreenRoute(isFromSplash: false),
                    predicate: (_) => false);
              } else {
                return responseBody['data'] as Map<String, dynamic>;
              }
            } else if (responseBody['status'] == true || forceReturn == true) {
              return responseBody;
            } else {
              if (notShowError != true) {
                showError(
                  title: 'Error',
                  errorMessage: responseBody['message'].toString(),
                  context: context,
                );
              }
              return null;
            }
          } else {
            if (notShowError != true) {
              showError(
                title: 'Error',
                errorMessage: response.statusMessage.toString(),
                context: context,
              );
            }
            return null;
          }
        }
      } on DioError catch (_) {
        if (context != null && notShowLoader != true) {
          processIndicator.hide(context);
        }
        if (notShowError != true) {
          showError(
            title: 'Error',
            errorMessage: "Somethings went wrong",
            context: context,
          );
        }
        return null;
      } catch (e) {
        if (context != null && notShowLoader != true) {
          processIndicator.hide(context);
        }
        if (notShowError != true) {
          showError(
            title: 'Error',
            errorMessage: "Somethings went wrong",
            context: context,
          );
        }
        return null;
      }
    } else {
      appRouter.push(const NoInternetScreenRoute());
      return null;
    }
    return null;
  }

  static Future<Map<String, dynamic>?> postDioHttpSpinWheel({
    BuildContext? context,
    bool? notShowError,
    required String url,
    required dynamic data,
  }) async {
    final bool internet = await check();
    if (internet) {
      if (context != null) {
        processIndicator.show(context);
      }
      try {
        if (await isValidSSLPinning(context, url)) {
          redirectToHackedPage(context);
        } else {
          final dio.Response<dynamic> response = await _dio.post(
            url,
            data: data,
          );
          Map<String, dynamic> responseBody = <String, dynamic>{};
          if (context != null) {
            processIndicator.hide(context);
          }

          if (response.statusCode == 200) {
            try {
              responseBody =
                  json.decode(response.data.toString()) as Map<String, dynamic>;
            } catch (e) {
              responseBody = response.data as Map<String, dynamic>;
            }
            if (responseBody['statuscode'] == 200) {
              if (responseBody['data']['status_code'] == "CC00011" ||
                  responseBody['data']['status_code'] == "CC00010") {
                StorageManager.setStringValue(
                  key: AppStorageKey.deletedAccountText,
                  value: responseBody['data']['message'],
                );
                appRouter.pushAndPopUntil(
                    DeletedAccountScreenRoute(isFromSplash: false),
                    predicate: (_) => false);
              } else {
                return responseBody['data'] as Map<String, dynamic>;
              }
            } else if (responseBody['status'] == true) {
              return responseBody;
            } else if (responseBody['statuscode'] == 800) {
              return responseBody;
            } else {
              if (notShowError != true) {
                showError(
                  title: 'Error',
                  errorMessage: responseBody['message'].toString(),
                  context: context,
                );
              }
              return null;
            }
          } else {
            if (notShowError != true) {
              showError(
                title: 'Error',
                errorMessage: response.statusMessage.toString(),
                context: context,
              );
            }
            return null;
          }
        }
      } on DioError catch (_) {
        if (context != null) {
          processIndicator.hide(context);
        }
        if (notShowError != true) {
          showError(
            title: 'Error',
            errorMessage: "Somethings went wrong",
            context: context,
          );
        }
        return null;
      } catch (e) {
        if (context != null) {
          processIndicator.hide(context);
        }
        if (notShowError != true) {
          showError(
            title: 'Error',
            errorMessage: "Somethings went wrong",
            context: context,
          );
        }
        return null;
      }
    } else {
      appRouter.push(const NoInternetScreenRoute());
      return null;
    }
    return null;
  }

  static Future<Map<String, dynamic>?> getDioHttpMethod({
    BuildContext? context,
    required String url,
    Map<String, dynamic>? queryParameters,
    bool? dontShowError,
    bool? noRedirect,
  }) async {
    final bool internet = await check();

    if (internet) {
      if (context != null) {
        processIndicator.show(context);
      }
      try {
        if (await isValidSSLPinning(context, url)) {
          redirectToHackedPage(context);
        } else {
          final dio.Response<dynamic> response = await _dio.get(
            url,
            queryParameters: queryParameters,
          );
          Map<String, dynamic> responseBody = <String, dynamic>{};
          if (context != null) {
            processIndicator.hide(context);
          }

          if (response.statusCode == 200) {
            try {
              responseBody =
                  json.decode(response.data.toString()) as Map<String, dynamic>;
            } catch (e) {
              responseBody = response.data as Map<String, dynamic>;
            }
            if (responseBody['statuscode'] == 200) {
              if (responseBody['data']['status_code'] == "CC00011" ||
                  responseBody['data']['status_code'] == "CC00010") {
                StorageManager.setStringValue(
                  key: AppStorageKey.deletedAccountText,
                  value: responseBody['data']['message'],
                );
                if (noRedirect == true) {
                  return null;
                }
                appRouter.pushAndPopUntil(
                    DeletedAccountScreenRoute(isFromSplash: false),
                    predicate: (_) => false);
              } else {
                return responseBody;
              }
            } else {
              if (dontShowError != true) {
                showError(
                  title: 'Error',
                  errorMessage: responseBody['message'].toString(),
                  context: context,
                );
              }
              return null;
            }
          } else {
            showError(
              title: 'Error',
              errorMessage: response.statusMessage.toString(),
              context: context,
            );
            return null;
          }
        }
      } on DioError catch (_) {
        if (context != null) {
          processIndicator.hide(context);
        }
        showError(
          title: 'Error',
          errorMessage: "Somethings went wrong",
          context: context,
        );
        return null;
      } catch (e) {
        if (context != null) {
          processIndicator.hide(context);
        }
        showError(
          title: 'Error',
          errorMessage: "Somethings went wrong",
          context: context,
        );
        return null;
      }
    } else {
      appRouter.push(const NoInternetScreenRoute());
      return null;
    }
    return null;
  }

  static Future<String> getRssFeed({
    BuildContext? context,
    required String url,
  }) async {
    final bool internet = await check();

    if (internet) {
      if (context != null) {
        processIndicator.show(context);
      }
      try {
        final dio.Response<dynamic> response =
            await _dio.get(url, options: Options(headers: rssHeader));
        String responseBody = '';
        if (context != null) {
          processIndicator.hide(context);
        }

        if (response.statusCode == 200) {
          try {
            responseBody = json.decode(response.data.toString());
            return responseBody.toString();
          } catch (e) {
            responseBody = response.data.toString();
            return responseBody.toString();
          }
        } else {
          showError(
            title: 'Error',
            errorMessage: response.statusMessage.toString(),
            context: context,
          );
          return '';
        }
      } on DioError catch (_) {
        if (context != null) {
          processIndicator.hide(context);
        }
        showError(
          title: 'Error',
          errorMessage: "Somethings went wrong",
          context: context,
        );
        return '';
      } catch (e) {
        if (context != null) {
          processIndicator.hide(context);
        }
        showError(
          title: 'Error',
          errorMessage: "Somethings went wrong",
          context: context,
        );
        return '';
      }
    } else {
      appRouter.push(const NoInternetScreenRoute());
      return '';
    }
  }

  static Future<Map<String, dynamic>?> putDioHttpMethod({
    BuildContext? context,
    required String url,
    required dynamic data,
  }) async {
    final bool internet = await check();
    if (internet) {
      if (context != null) {
        processIndicator.show(context);
      }
      try {
        if (await isValidSSLPinning(context, url)) {
          redirectToHackedPage(context);
        } else {
          final dio.Response<dynamic> response = await _dio.put(
            url,
            data: data,
          );
          Map<String, dynamic> responseBody = <String, dynamic>{};
          if (context != null) {
            processIndicator.hide(context);
          }

          if (response.statusCode == 200) {
            try {
              responseBody =
                  json.decode(response.data.toString()) as Map<String, dynamic>;
            } catch (e) {
              responseBody = response.data as Map<String, dynamic>;
            }
            if (responseBody['statuscode'] == 200) {
              if (responseBody['data']['status_code'] == "CC00011" ||
                  responseBody['data']['status_code'] == "CC00010") {
                StorageManager.setStringValue(
                  key: AppStorageKey.deletedAccountText,
                  value: responseBody['data']['message'],
                );
                appRouter.pushAndPopUntil(
                    DeletedAccountScreenRoute(isFromSplash: false),
                    predicate: (_) => false);
              } else {
                return responseBody['data'] as Map<String, dynamic>;
              }
            } else {
              showError(
                title: 'Error',
                errorMessage: responseBody['message'].toString(),
                context: context,
              );
              return null;
            }
          } else {
            showError(
              title: 'Error',
              errorMessage: response.statusMessage.toString(),
              context: context,
            );
            return null;
          }
        }
      } on DioError catch (_) {
        if (context != null) {
          processIndicator.hide(context);
        }
        showError(
          title: 'Error',
          errorMessage: "Somethings went wrong",
          context: context,
        );
        return null;
      } catch (e) {
        if (context != null) {
          processIndicator.hide(context);
        }
        showError(
          title: 'Error',
          errorMessage: "Somethings went wrong",
          context: context,
        );
        return null;
      }
    } else {
      appRouter.push(const NoInternetScreenRoute());
      return null;
    }
    return null;
  }

  //CMS dio
  static Future<Map<String, dynamic>?> getDioHttpMethodCMS(
      {BuildContext? context,
      required String url,
      Map<String, dynamic>? queryParams}) async {
    final bool internet = await check();
    if (internet) {
      if (context != null) {
        processIndicator.show(context);
      }
      try {
        if (await isValidSSLPinning(context, url)) {
          redirectToHackedPage(context);
        } else {
          final dio.Response<dynamic> response = await _dio.get(
            url,
            queryParameters: queryParams,
          );
          Map<String, dynamic> responseBody = <String, dynamic>{};
          if (context != null) {
            processIndicator.hide(context);
          }

          if (response.statusCode == 200) {
            try {
              responseBody =
                  json.decode(response.data.toString()) as Map<String, dynamic>;
            } catch (e) {
              responseBody = response.data as Map<String, dynamic>;
            }
            if (responseBody['status_code'] == "SCR_0001" ||
                responseBody['status_code'] == "SCR_0002") {
              return responseBody;
            } else {
              showError(
                title: 'Error',
                errorMessage: responseBody['message'].toString(),
                context: context,
              );
              return null;
            }
          } else {
            showError(
              title: 'Error',
              errorMessage: response.statusMessage.toString(),
              context: context,
            );
            return null;
          }
        }
      } on DioError catch (_) {
        if (context != null) {
          processIndicator.hide(context);
        }
        showError(
          title: 'Error',
          errorMessage: "Somethings went wrong",
          context: context,
        );
        return null;
      } catch (e) {
        if (context != null) {
          processIndicator.hide(context);
        }
        showError(
          title: 'Error',
          errorMessage: "Somethings went wrong",
          context: context,
        );
        return null;
      }
    } else {
      appRouter.push(const NoInternetScreenRoute());
      return null;
    }
    return null;
  }

  static Future<Map<String, dynamic>?> getGiftVoucherDioHttpMethod({
    BuildContext? context,
    required String url,
    bool? notShowError,
    Map<String, dynamic>? queryParameters,
  }) async {
    final bool internet = await check();
    if (internet) {
      if (context != null) {
        processIndicator.show(context);
      }
      try {
        if (await isValidSSLPinning(context, url)) {
          redirectToHackedPage(context);
        } else {
          final dio.Response<dynamic> response = await _dio.get(
            url,
            queryParameters: queryParameters,
            options: Options(headers: giftVoucherHeader),
          );
          Map<String, dynamic> responseBody = <String, dynamic>{};
          if (context != null) {
            processIndicator.hide(context);
          }

          if (response.statusCode == 200) {
            try {
              responseBody =
                  json.decode(response.data.toString()) as Map<String, dynamic>;
            } catch (e) {
              responseBody = response.data as Map<String, dynamic>;
            }
            return responseBody;
          } else {
            if (notShowError != true) {
              showError(
                title: 'Error',
                errorMessage: response.statusMessage.toString(),
                context: context,
              );
            }
            return null;
          }
        }
      } on DioError catch (_) {
        if (context != null) {
          processIndicator.hide(context);
        }
        if (notShowError != true) {
          showError(
            title: 'Error',
            errorMessage: "Somethings went wrong",
            context: context,
          );
        }
        return null;
      } catch (e) {
        if (context != null) {
          processIndicator.hide(context);
        }
        if (notShowError != true) {
          showError(
            title: 'Error',
            errorMessage: "Somethings went wrong",
            context: context,
          );
        }
        return null;
      }
    } else {
      appRouter.push(const NoInternetScreenRoute());
      return null;
    }
    return null;
  }

  static Future<Map<String, dynamic>?> postGiftVoucherDioHttpMethod({
    BuildContext? context,
    bool? notShowError,
    required String url,
    required dynamic data,
  }) async {
    final bool internet = await check();
    if (internet) {
      if (context != null) {
        processIndicator.show(context);
      }
      try {
        if (await isValidSSLPinning(context, url)) {
          redirectToHackedPage(context);
        } else {
          final dio.Response<dynamic> response = await _dio.post(
            url,
            data: data,
            options: Options(headers: giftVoucherHeader),
          );
          Map<String, dynamic> responseBody = <String, dynamic>{};
          if (context != null) {
            processIndicator.hide(context);
          }
          if (response.statusCode == 200) {
            try {
              if(response.data!="") {
                responseBody = json.decode(response.data.toString())
                    as Map<String, dynamic>;
              }
            } catch (e) {
              if(response.data!="") {
              responseBody = response.data as Map<String, dynamic>;}
            }
            return responseBody;
          } else {
            if (notShowError != true) {
              showError(
                title: 'Error',
                errorMessage: response.statusMessage.toString(),
                context: context,
              );
            }
            return null;
          }
        }
      } on DioError catch (_) {
        if (context != null) {
          processIndicator.hide(context);
        }
        if (notShowError != true) {
          showError(
            title: 'Error',
            errorMessage: "Somethings went wrong",
            context: context,
          );
        }
        return null;
      } catch (e) {
        if (context != null) {
          processIndicator.hide(context);
        }
        if (notShowError != true) {
          showError(
            title: 'Error',
            errorMessage: "Somethings went wrong",
            context: context,
          );
        }
        return null;
      }
    } else {
      appRouter.push(const NoInternetScreenRoute());
      return null;
    }
    return null;
  }

  static Future<String?> postDioHttpMethodSSOStr({
    BuildContext? context,
    required String url,
    required dynamic data,
  }) async {
    final bool internet = await check();
    if (internet) {
      if (context != null) {
        processIndicator.show(context);
      }
      try {
        if (await isValidSSLPinning(context, url)) {
          redirectToHackedPage(context);
        } else {
          final dio.Response<dynamic> response = await _dio.post(
            url,
            data: data,
          );
          if (context != null) {
            processIndicator.hide(context);
          }
          if (response.statusCode == 200) {
            try {
              if (response.data['link'] != null ||
                  response.data['link'] != "") {
                return response.data['link'];
              } else {
                return response.data['msg'];
              }
            } catch (e) {
              return response.data['message'];
            }
          } else if (response.statusCode == 401) {
            showError(
              title: 'Error',
              errorMessage: response.statusMessage.toString(),
              context: context,
            );
          } else {
            showError(
              title: 'Error',
              errorMessage: response.statusMessage.toString(),
              context: context,
            );
            return null;
          }
        }
      } on DioError catch (_) {
        if (context != null) {
          processIndicator.hide(context);
        }
        showError(
          title: 'Error',
          errorMessage: "Somethings went wrong",
          context: context,
        );
        return null;
      } catch (e) {
        if (context != null) {
          processIndicator.hide(context);
        }
        showError(
          title: 'Error',
          errorMessage: "Somethings went wrong",
          context: context,
        );
        return null;
      }
    } else {
      appRouter.push(const NoInternetScreenRoute());
      return null;
    }
    return null;
  }

  static Future<Map<String, dynamic>?> postDioHttpMethodSSO({
    BuildContext? context,
    required String url,
    required dynamic data,
  }) async {
    final bool internet = await check();
    if (internet) {
      try {
        if (context != null) {
          processIndicator.show(context);
        }
        if (await isValidSSLPinning(context, url)) {
          redirectToHackedPage(context);
        } else {
          final dio.Response<dynamic> response = await _dio.post(
            url,
            data: data,
          );
          Map<String, dynamic> responseBody = <String, dynamic>{};
          if (context != null) {
            processIndicator.hide(context);
          }
          if (response.statusCode == 200) {
            try {
              try {
                responseBody = json.decode(response.data.toString())
                    as Map<String, dynamic>;
              } catch (e) {
                responseBody = response.data as Map<String, dynamic>;
              }
              return responseBody;
            } catch (e) {
              return response.data['message'];
            }
          } else if (response.statusCode == 401) {
            showError(
              title: 'Error',
              errorMessage: response.statusMessage.toString(),
              context: context,
            );
          } else {
            showError(
              title: 'Error',
              errorMessage: response.statusMessage.toString(),
              context: context,
            );
            return null;
          }
        }
      } on DioError catch (_) {
        if (context != null) {
          processIndicator.hide(context);
        }
        showError(
          title: 'Error',
          errorMessage: "Somethings went wrong",
          context: context,
        );
        return null;
      } catch (e) {
        if (context != null) {
          processIndicator.hide(context);
        }
        showError(
          title: 'Error',
          errorMessage: "Somethings went wrong",
          context: context,
        );
        return null;
      }
    } else {
      appRouter.push(const NoInternetScreenRoute());
      return null;
    }
    return null;
  }

  static Future<Map<String, dynamic>?> postPartnerNetworkDio({
    BuildContext? context,
    required String url,
    required dynamic data,
  }) async {
    final bool internet = await check();
    if (internet == true) {
      if (context != null) {
        processIndicator.show(context);
      }
      try {
        if (await isValidSSLPinning(context, url)) {
          redirectToHackedPage(context);
        } else {
          final dio.Response<dynamic> response = await _dio.post(
            url,
            data: data,
          );
          Map<String, dynamic> responseBody = <String, dynamic>{};
          if (context != null) {
            processIndicator.hide(context);
          }

          if (response.statusCode == 200) {
            try {
              responseBody =
                  json.decode(response.data.toString()) as Map<String, dynamic>;
            } catch (e) {
              responseBody = response.data as Map<String, dynamic>;
            }
            return responseBody;
          } else {
            responseBody =
                json.decode(response.data.toString()) as Map<String, dynamic>;
            showError(
              title: 'Error',
              errorMessage: responseBody['message'].toString(),
              context: context,
            );
            return null;
          }
        }
      } on DioError catch (_) {
        if (context != null) {
          processIndicator.hide(context);
        }
        showError(
          title: 'Error',
          errorMessage: 'Somethings went wrong',
          context: context,
        );
        return null;
      } catch (e) {
        if (context != null) {
          processIndicator.hide(context);
        }
        showError(
          title: 'Error',
          errorMessage: "Somethings went wrong",
          context: context,
        );
        return null;
      }
    } else {
      appRouter.push(const NoInternetScreenRoute());
      return null;
    }
    return null;
  }

  static Future<Map<String, dynamic>?> postOfferListCat({
    BuildContext? context,
    required String url,
    required dynamic data,
  }) async {
    final bool internet = await check();
    if (internet) {
      if (context != null) {
        processIndicator.show(context);
      }
      try {
        if (await isValidSSLPinning(context, url)) {
          redirectToHackedPage(context);
        } else {
          final dio.Response<dynamic> response = await _dio.post(
            url,
            data: data,
          );
          Map<String, dynamic> responseBody = <String, dynamic>{};
          if (context != null) {
            processIndicator.hide(context);
          }

          if (response.statusCode == 200) {
            try {
              responseBody =
                  json.decode(response.data.toString()) as Map<String, dynamic>;
            } catch (e) {
              responseBody = response.data as Map<String, dynamic>;
            }
            return responseBody;
          } else {
            showError(
              title: 'Error',
              errorMessage: response.statusMessage.toString(),
              context: context,
            );
            return null;
          }
        }
      } on DioError catch (_) {
        if (context != null) {
          processIndicator.hide(context);
        }
        showError(
          title: 'Error',
          errorMessage: 'Somethings went wrong',
          context: context,
        );
        return null;
      } catch (e) {
        if (context != null) {
          processIndicator.hide(context);
        }
        showError(
          title: 'Error',
          errorMessage: "Somethings went wrong",
          context: context,
        );
        return null;
      }
    } else {
      appRouter.push(const NoInternetScreenRoute());
      return null;
    }
    return null;
  }

  static Future<Map<String, dynamic>?> postCheckUpdateNetworkDio({
    BuildContext? context,
    required String url,
    required dynamic data,
  }) async {
    final bool internet = await check();
    if (internet) {
      /*if (context != null) {
        processIndicator.show(context);
      }*/
      try {
        if (await isValidSSLPinning(context, url)) {
          redirectToHackedPage(context);
        } else {
          final dio.Response<dynamic> response = await _dio.post(
            url,
            data: data,
          );
          Map<String, dynamic> responseBody = <String, dynamic>{};
          /*if (context != null) {
          processIndicator.hide(context);
        }*/

          if (response.statusCode == 200) {
            try {
              responseBody =
                  json.decode(response.toString()) as Map<String, dynamic>;
            } catch (e) {
              responseBody = response.data as Map<String, dynamic>;
            }
            return responseBody;
          } else {
            responseBody =
                json.decode(response.toString()) as Map<String, dynamic>;
            showError(
              title: 'Error',
              errorMessage: responseBody['message'].toString(),
              context: context,
            );
            return null;
          }
        }
      } on DioError catch (_) {
        showError(
          title: 'Error',
          errorMessage: 'Somethings went wrong',
          context: context,
        );
        return null;
      } catch (e) {
        showError(
          title: 'Error',
          errorMessage: "Somethings went wrong",
          context: context,
        );
        return null;
      }
    } else {
      appRouter.push(const NoInternetScreenRoute());
      return null;
    }
    return null;
  }

  static void showSuccess({
    required String title,
    required String sucessMessage,
    BuildContext? context,
  }) {
    if (context != null) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text(sucessMessage),
      //     backgroundColor: AppColors.successColor,
      //   ),

      // );
      //
      popupBottomSheet(context, sucessMessage);
    }
  }

  static void showWarning({
    required String message,
    BuildContext? context,
    bool? isDimissible,
  }) {
    if (context != null) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text(message),
      //     backgroundColor: AppColors.blueColor,
      //   ),
      // );
      popupBottomSheet(
        context,
        message,
        isDimissible: isDimissible,
      );
    }
  }

  static void showError({
    required String title,
    required String errorMessage,
    BuildContext? context,
  }) {
    if (context != null) {
      popupBottomSheet(context, errorMessage);
      //ScaffoldMessenger.of(context).showSnackBar(

      // SnackBar(
      //   content: Text(errorMessage),
      //   backgroundColor: AppColors.errorColor,
      // ),
      // );
    }
  }
}

Future<void> popupBottomSheet(BuildContext buildContext, String text,
    {bool? isDimissible}) async {
  final completer = Completer<void>();

  showModalBottomSheet(
    backgroundColor: AppColors.secondaryContainerColor,
    context: buildContext,
    isDismissible: isDimissible ?? true,
    enableDrag: isDimissible ?? true,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20.0),
        topRight: Radius.circular(20.0),
      ),
    ),
    builder: (context) {
      Future.delayed(const Duration(seconds: 3)).then((_) {
        if (!completer.isCompleted) {
          Navigator.pop(context); // Close the bottom sheet
          completer.complete();
        }
      });

      return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Padding(
          padding: EdgeInsets.only(
            top: AppSizes.size20,
            right: AppSizes.size20,
            left: AppSizes.size20,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: AppTextStyle.semiBold14.copyWith(
                    color: AppColors.darkBlueTextColor,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(
                  height: AppSizes.size30,
                ),
                const SizedBox(
                  height: AppSizes.size20,
                ),
              ],
            ),
          ),
        ),
      );
    },
  ).then((value) {
    if (!completer.isCompleted) {
      completer.complete();
    }
  });

  return completer.future;
}
