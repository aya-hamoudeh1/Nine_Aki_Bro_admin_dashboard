import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nine_aki_bro_admin_panel/core/components/custom_circle_pro_ind.dart';
import 'package:nine_aki_bro_admin_panel/core/functions/navigate_without_back.dart';
import 'package:nine_aki_bro_admin_panel/core/functions/show_msg.dart';
import 'package:nine_aki_bro_admin_panel/features/home/view/home_view.dart';
import 'package:nine_aki_bro_admin_panel/features/products/cubit/products_cubit.dart';
import '../../../core/components/cache_image.dart';
import '../../../core/components/custom_elevated_button.dart';
import '../../../core/components/custom_text_field.dart';
import '../../../core/functions/build_appbar.dart';
import '../../../core/functions/pick_image.dart';

class AddProductView extends StatefulWidget {
  const AddProductView({super.key});

  @override
  State<AddProductView> createState() => _AddProductViewState();
}

class _AddProductViewState extends State<AddProductView> {
  String discount = '';
  String? selectedValue;
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _newPriceController = TextEditingController();
  final TextEditingController _oldPriceController = TextEditingController();
  final TextEditingController _productDescriptionController =
      TextEditingController();

  Uint8List? _selectedImage;
  String _imageName = 'Image Name';

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProductsCubit>();
    final isWide = MediaQuery.of(context).size.width > 600;

    return BlocConsumer<ProductsCubit, ProductsState>(
      listener: (context, state) {
        if (state is AddProductSuccess) {
          showMsg(context, "Product added successfully");
          setState(() {
            _selectedImage = null;
            _imageName = 'Image Name';
            _productNameController.clear();
            _newPriceController.clear();
            _oldPriceController.clear();
            _productDescriptionController.clear();
            selectedValue = null;
            discount = '';
            cubit.imageUrl = '';
          });
          navigateWithoutBack(context, HomeView());
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: buildCustomAppBar(context, "Add Product"),
          body:
              state is AddProductLoading
                  ? const CustomCircleProgressIndicator()
                  : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListView(
                      children: [
                        if (state is UploadImageLoading ||
                            state is AddProductLoading)
                          const LinearProgressIndicator(),
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
                                    hintText: 'Select Category',
                                    onSelected: (value) {
                                      setState(() {
                                        selectedValue = value;
                                      });
                                    },
                                    initialSelection: selectedValue,
                                    dropdownMenuEntries:
                                        cubit.categories.map((cat) {
                                          return DropdownMenuEntry(
                                            value: cat.categoryId,
                                            label: cat.title,
                                          );
                                        }).toList(),
                                  ),
                                ),

                                /// Discount Display
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Sale',
                                      style:
                                          Theme.of(
                                            context,
                                          ).textTheme.titleMedium,
                                    ),
                                    Text(
                                      '$discount %',
                                      style:
                                          Theme.of(
                                            context,
                                          ).textTheme.titleLarge,
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
                                            url: cubit.imageUrl,
                                            width: 300,
                                            height: 200,
                                          ),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          CustomElevatedButton(
                                            child: const Icon(
                                              Icons.image_outlined,
                                            ),
                                            onPressed: () async {
                                              final value = await pickImage();
                                              if (value != null) {
                                                setState(() {
                                                  _imageName =
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
                                                      if (_selectedImage !=
                                                          null) {
                                                        await cubit.uploadImage(
                                                          image:
                                                              _selectedImage!,
                                                          imageName: _imageName,
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

                        /// Product Name
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
                              discount = x.round().toString();
                            });
                          },
                        ),
                        const SizedBox(height: 10),

                        /// Product Description
                        CustomTextField(
                          labelText: 'Product Description',
                          controller: _productDescriptionController,
                        ),
                        const SizedBox(height: 40),

                        /// Add Button
                        SizedBox(
                          width: isWide ? 300 : double.infinity,
                          child: CustomElevatedButton(
                            onPressed:
                                state is AddProductLoading
                                    ? null
                                    : () {
                                      if (_productNameController.text.isEmpty ||
                                          _newPriceController.text.isEmpty ||
                                          _oldPriceController.text.isEmpty ||
                                          _productDescriptionController
                                              .text
                                              .isEmpty) {
                                        showMsg(
                                          context,
                                          "Please fill in all required fields",
                                        );
                                        return;
                                      }

                                      if (selectedValue == null) {
                                        showMsg(
                                          context,
                                          "Please select a category",
                                        );
                                        return;
                                      }
                                      if (cubit.imageUrl.isEmpty) {
                                        showMsg(
                                          context,
                                          "Please upload a product image",
                                        );
                                        return;
                                      }

                                      cubit.addProduct(
                                        data: {
                                          "product_name":
                                              _productNameController.text,
                                          "price": _newPriceController.text,
                                          "old_price": _oldPriceController.text,
                                          "sale": discount,
                                          "description":
                                              _productDescriptionController
                                                  .text,
                                          "image_url": cubit.imageUrl,
                                          "category_id": selectedValue,
                                        },
                                      );
                                    },
                            child: const Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Text('Add'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
        );
      },
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
