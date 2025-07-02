part of 'products_cubit.dart';

@immutable
sealed class ProductsState {}

final class ProductsInitial extends ProductsState {}

/// Get Products
final class GetProductsLoading extends ProductsState {}

final class GetProductsSuccess extends ProductsState {}

final class GetProductsError extends ProductsState {}

/// Category
final class CategoryLoading extends ProductsState {}

final class CategorySuccess extends ProductsState {}

final class CategoryError extends ProductsState {}

/// Upload Image
final class UploadImageLoading extends ProductsState {}

final class UploadImageSuccess extends ProductsState {}

final class UploadImageError extends ProductsState {}

/// Edit Product
final class EditProductLoading extends ProductsState {}

final class EditProductSuccess extends ProductsState {}

final class EditProductError extends ProductsState {}

/// Delete Product
final class DeleteProductLoading extends ProductsState {}

final class DeleteProductSuccess extends ProductsState {}

final class DeleteProductError extends ProductsState {}

/// Add Product
final class AddProductLoading extends ProductsState {}

final class AddProductSuccess extends ProductsState {}

final class AddProductError extends ProductsState {}

/// Get Comments
class GetCommentsLoading extends ProductsState {}

class GetCommentsSuccess extends ProductsState {}

class GetCommentsError extends ProductsState {}

/// Add Reply
class AddReplyLoading extends ProductsState {}

class AddReplySuccess extends ProductsState {}

class AddReplyError extends ProductsState {}
