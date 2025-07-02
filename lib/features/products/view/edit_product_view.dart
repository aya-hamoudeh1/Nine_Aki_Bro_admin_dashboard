import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nine_aki_bro_admin_panel/core/functions/navigate_without_back.dart';
import 'package:nine_aki_bro_admin_panel/core/functions/show_msg.dart';
import 'package:nine_aki_bro_admin_panel/features/home/view/home_view.dart';
import '../../../core/components/cache_image.dart';
import '../../../core/components/custom_circle_pro_ind.dart';
import '../../../core/components/custom_elevated_button.dart';
import '../../../core/components/custom_text_field.dart';
import '../../../core/functions/build_appbar.dart';
import '../../../core/functions/pick_image.dart';
import '../cubit/products_cubit.dart';
import '../models/product_model.dart';

class EditProductView extends StatefulWidget {
  const EditProductView({super.key, required this.product});

  final ProductModel product;

  @override
  State<EditProductView> createState() => _EditProductViewState();
}

class _EditProductViewState extends State<EditProductView> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _newPriceController = TextEditingController();
  final TextEditingController _oldPriceController = TextEditingController();
  final TextEditingController _productDescriptionController =
      TextEditingController();

  Uint8List? _selectedImage;
  String _selectedImageName = 'Image Name';
  String? _uploadedImageUrl;
  String? _selectedCategoryId;
  String? _discount;

  @override
  void initState() {
    super.initState();
    _selectedCategoryId = widget.product.categoryId;
    _discount = widget.product.sale?.toString();
    _productNameController.text = widget.product.productName ?? '';
    _newPriceController.text = widget.product.price.toString();
    _oldPriceController.text = widget.product.oldPrice.toString();
    _productDescriptionController.text = widget.product.description ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProductsCubit>();
    final isWide = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: buildCustomAppBar(context, "Edit Product"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocListener<ProductsCubit, ProductsState>(
          listener: (context, state) {
            if (state is EditProductSuccess) {
              navigateWithoutBack(context, HomeView());
            } else if (state is UploadImageSuccess) {
              setState(() {
                _uploadedImageUrl = cubit.imageUrl;
              });
              showMsg(context, "Image uploaded successfully");
            } else if (state is UploadImageError) {
              showMsg(context, "Image upload failed");
            }
          },
          child: BlocBuilder<ProductsCubit, ProductsState>(
            builder: (context, state) {
              if (state is CategoryLoading) {
                return const CustomCircleProgressIndicator();
              }

              if (state is CategoryError) {
                return const Center(child: Text("Failed to load categories"));
              }

              final categories = cubit.categories;

              return Form(
                key: _formKey,
                child: ListView(
                  children: [
                    if (state is UploadImageLoading ||
                        state is EditProductLoading)
                      const LinearProgressIndicator(),

                    const SizedBox(height: 20),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        return Wrap(
                          spacing: 20,
                          runSpacing: 20,
                          alignment: WrapAlignment.spaceEvenly,
                          children: [
                            /// Category Dropdown
                            SizedBox(
                              width: isWide ? 250 : double.infinity,
                              child: DropdownMenu<String>(
                                onSelected:
                                    (value) => setState(
                                      () => _selectedCategoryId = value,
                                    ),
                                initialSelection: _selectedCategoryId,
                                dropdownMenuEntries:
                                    categories.map((category) {
                                      return DropdownMenuEntry(
                                        value: category.categoryId,
                                        label: category.title,
                                      );
                                    }).toList(),
                              ),
                            ),

                            /// Discount View
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Discount',
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                Text(
                                  '$_discount %',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                              ],
                            ),

                            /// Image Picker + Preview
                            SizedBox(
                              width: isWide ? 320 : double.infinity,
                              child: Column(
                                children: [
                                  _selectedImage != null
                                      ? Image.memory(
                                        _selectedImage!,
                                        width: 300,
                                        height: 200,
                                      )
                                      : CacheImage(
                                        url: widget.product.imageUrl ?? '',
                                        width: 300,
                                        height: 200,
                                      ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CustomElevatedButton(
                                        child: const Icon(Icons.image_outlined),
                                        onPressed: () async {
                                          final value = await pickImage();
                                          if (value != null) {
                                            setState(() {
                                              _selectedImageName =
                                                  value.files.first.name;
                                              _selectedImage =
                                                  value.files.first.bytes;
                                            });
                                          }
                                        },
                                      ),
                                      const SizedBox(width: 10),
                                      CustomElevatedButton(
                                        onPressed:
                                            state is UploadImageLoading
                                                ? null
                                                : () async {
                                                  if (_selectedImage != null) {
                                                    await cubit.uploadImage(
                                                      image: _selectedImage!,
                                                      imageName:
                                                          _selectedImageName,
                                                      bucketName: 'images',
                                                    );
                                                  }
                                                },
                                        child: const Icon(
                                          Icons.upload_file_outlined,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),

                    const SizedBox(height: 30),

                    /// Fields
                    CustomTextField(
                      labelText: 'Product Name',
                      controller: _productNameController,
                    ),
                    const SizedBox(height: 10),

                    /// Old Price
                    CustomTextField(
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^(\d+)?\.?\d{0,2}'),
                        ),
                      ],
                      labelText: 'Old Price (Before Discount)',
                      controller: _oldPriceController,
                    ),
                    const SizedBox(height: 10),

                    /// New Price
                    CustomTextField(
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^(\d+)?\.?\d{0,2}'),
                        ),
                      ],
                      labelText: 'New Price (After Discount)',
                      controller: _newPriceController,
                      onChanged: (p0) {
                        final old =
                            double.tryParse(_oldPriceController.text) ?? 1;
                        final newP = double.tryParse(p0) ?? 0;
                        double x = ((old - newP) / old) * 100;
                        setState(() {
                          _discount = x.round().toString();
                        });
                      },
                    ),
                    const SizedBox(height: 10),

                    CustomTextField(
                      labelText: 'Product Description',
                      controller: _productDescriptionController,
                    ),
                    const SizedBox(height: 40),

                    /// Update Button
                    Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: isWide ? 300 : double.infinity,
                        child: CustomElevatedButton(
                          onPressed:
                              (state is EditProductLoading)
                                  ? null
                                  : () {
                                    if (_formKey.currentState!.validate()) {
                                      if (_selectedCategoryId == null) {
                                        showMsg(
                                          context,
                                          "Please select a category",
                                        );
                                        return;
                                      }

                                      cubit.editProduct(
                                        productId: widget.product.productId!,
                                        data: {
                                          "product_name":
                                              _productNameController.text,
                                          "price": _newPriceController.text,
                                          "old_price": _oldPriceController.text,
                                          "sale": _discount,
                                          "description":
                                              _productDescriptionController
                                                  .text,
                                          "image_url":
                                              _uploadedImageUrl ??
                                              widget.product.imageUrl,
                                          "category_id": _selectedCategoryId,
                                        },
                                      );
                                    }
                                  },
                          child: const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Text('Update'),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _newPriceController.dispose();
    _oldPriceController.dispose();
    _productDescriptionController.dispose();
    super.dispose();
  }
}