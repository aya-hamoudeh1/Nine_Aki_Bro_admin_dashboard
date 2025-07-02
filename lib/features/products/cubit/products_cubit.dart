import 'dart:developer';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/api/api_services.dart';
import '../../../core/helpers/shared_preferences.dart';
import '../../../core/sensitive_data.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';
part 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit() : super(ProductsInitial());

  final ApiServices _apiServices = ApiServices();
  List<CategoryModel> categories = [];
  List<ProductModel> products = [];
  List<Map<String, dynamic>> comments = [];


  /// Get Products
  Future<void> getProducts() async {
    emit(GetProductsLoading());
    try {
      String? token = await SharedPref.getToken();
      Response response = await _apiServices.getData('products', token);
      for (Map<String, dynamic> product in response.data) {
        products.add(ProductModel.fromJson(product));
      }
      emit(GetProductsSuccess());
    } catch (e) {
      log(e.toString());
      emit(GetProductsError());
    }
  }

  /// Category
  Future<void> getCategories() async {
    emit(CategoryLoading());
    try {
      String? token = await SharedPref.getToken();
      Response response = await _apiServices.getData('category', token);
      categories =
          (response.data as List)
              .map((category) => CategoryModel.fromJson(category))
              .toList();
      emit(CategorySuccess());
    } catch (e) {
      emit(CategoryError());
      log(e.toString());
    }
  }

  /// Upload Image To Supabase Storage
  String imageUrl = '';
  Future<void> uploadImage({
    required Uint8List image,
    required String imageName,
    required String bucketName,
  }) async {
    emit(UploadImageLoading());
    const String storageBaseUrl =
        'https://roukbxhlisygcczaneiw.supabase.co/storage/v1/object';
    String apiKey = anonKey;
    final String? token = await SharedPref.getToken();
    final String uploadUrl = '$storageBaseUrl/$bucketName/$imageName';
    final Dio dio = Dio();
    FormData formData = FormData.fromMap({
      "file": MultipartFile.fromBytes(image as List<int>, filename: imageName),
    });
    try {
      Response response = await dio.post(
        data: formData,
        uploadUrl,
        options: Options(
          headers: {
            "apikey": apiKey,
            "Authorization": "Bearer $token",
            "Content-Type": "multipart/form-data",
          },
        ),
      );
      if (response.statusCode == 200) {
        imageUrl =
            'https://roukbxhlisygcczaneiw.supabase.co/storage/v1/object/public/${response.data['Key']}';
        log(response.data['Key']);
        emit(UploadImageSuccess());
      } else {
        emit(UploadImageError());
      }
    } catch (e) {
      log(e.toString());
      emit(UploadImageError());
    }
  }

  /// Edit Product
  Future<void> editProduct({
    required Map<String, dynamic> data,
    required String productId,
  }) async {
    emit(EditProductLoading());
    try {
      final String? token = await SharedPref.getToken();
      Response response = await _apiServices.patchData(
        'products?product_id=eq.$productId',
        data,
        token,
      );
      if (response.statusCode == 204) {
        emit(EditProductSuccess());
      }
    } catch (e) {
      log(e.toString());
      emit(EditProductError());
    }
  }

  /// Delete Product
  Future<void> deleteProduct({required String productId}) async {
    emit(DeleteProductLoading());
    try {
      final String? token = await SharedPref.getToken();

      /// Delete the related table for this product
      await _apiServices.deleteData(
        "comments?for_product=eq.$productId",
        token,
      );
      await _apiServices.deleteData(
        "favorite?for_product=eq.$productId",
        token,
      );
      await _apiServices.deleteData("rates?for_product=eq.$productId", token);
      await _apiServices.deleteData(
        "purchase?for_product=eq.$productId",
        token,
      );
      await _apiServices.deleteData("cart?for_product=eq.$productId", token);
      await _apiServices.deleteData(
        "product_variants?for_product=eq.$productId",
        token,
      );

      /// Delete Product
      await _apiServices.deleteData("products?product_id=eq.$productId", token);
      emit(DeleteProductSuccess());
    } catch (e) {
      log(e.toString());
      emit(DeleteProductError());
    }
  }

  /// Add Product
  Future<void> addProduct({required Map<String, dynamic> data}) async {
    emit(AddProductLoading());
    try {
      final String? token = await SharedPref.getToken();
      await _apiServices.postData('products', data, token);
      emit(AddProductSuccess());
    } catch (e) {
      log(e.toString());
      emit(AddProductError());
    }
  }

  /// Get Comments
  Future<void> getCommentsForProduct(String productId) async {
    emit(GetCommentsLoading());
    try {
      final String? token = await SharedPref.getToken();
      final response = await _apiServices.getData(
        'comments?for_product=eq.$productId',
        token,
      );
      comments = List<Map<String, dynamic>>.from(response.data);
      emit(GetCommentsSuccess());
    } catch (e) {
      log('Error fetching comments: $e');
      emit(GetCommentsError());
    }
  }

  /// Add Reply To Comment
  Future<void> addReplyToComment({
    required String commentId,
    required String reply,
  }) async {
    emit(AddReplyLoading());
    try {
      final String? token = await SharedPref.getToken();
      await _apiServices.patchData(
        'comments?comment_id=eq.$commentId',
        {'reply': reply},
        token,
      );
      emit(AddReplySuccess());
    } catch (e) {
      log('Error replying to comment: $e');
      emit(AddReplyError());
    }
  }

}
