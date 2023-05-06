import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pharma_app/src/app_assets.dart';
import 'package:pharma_app/src/components/async_value_widget.dart';
import 'package:pharma_app/src/helpers/extensions.dart';
import 'package:pharma_app/src/models/address.dart';

import '../../../providers/user_addresses_provider.dart';
import '../../../repository/addresses_repository.dart';

class Addresses extends ConsumerStatefulWidget {
  const Addresses({Key? key}) : super(key: key);

  @override
  ConsumerState<Addresses> createState() => _AddressesState();
}

class _AddressesState extends ConsumerState<Addresses> {
  final scrollController = ScrollController();
  late String _addressId;

  @override
  void initState() {
    getAddressId();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final addresses = ref.watch(userAddressesProvider);
//TODO stringhe
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Scegli indirizzo di consegna",
          style: context.textTheme.bodyText2?.copyWith(fontSize: 20),
        ),
        const SizedBox(
          height: 30,
        ),
        ConstrainedBox(
          constraints:
              BoxConstraints(maxWidth: context.mqw * 0.90, maxHeight: 330),
          child: AsyncValueWidget<List<Address>>(
              value: addresses,
              data: (addressesList) {
                return ListView.builder(
                  controller: scrollController,
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: addressesList.length,
                  itemBuilder: (_, int index) {
                    final address = addressesList[index];
                    return AddressListTile(
                      title: Text(address.description!),
                      subtitle: Text(address.address!, //TODO colore gray 4
                          style: context.textTheme.subtitle2?.copyWith(
                              fontSize: 14, color: const Color(0XFFBDBDBD))),
                      value: address.id ?? '',
                      groupValue: _addressId,
                      onChanged: (String? value) {
                        setState(() {
                          _addressId = value!;
                          address.isDefault = true;
                          updateAddress(address);
                        });
                        ref.refresh(userAddressesProvider.future);
                      },
                    );
                  },
                );
              }),
        ),
      ],
    );
  }

  void getAddressId() async {
    final address = await getDefaultAddress();
    setState(() {
      _addressId = address.id!;
    });
  }
}

class AddressListTile extends StatefulWidget {
  final String value;
  final String? groupValue;
  final void Function(String?)? onChanged;
  final Widget? title;
  final Widget? subtitle;

  const AddressListTile({
    Key? key,
    required this.value,
    this.groupValue,
    this.onChanged,
    this.title,
    this.subtitle,
  }) : super(key: key);

  @override
  State<AddressListTile> createState() => _AddressListTileState();
}

class _AddressListTileState extends State<AddressListTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: DecoratedBox(
          decoration: BoxDecoration(
            //TODO colore bordo
            border: Border.all(color: const Color(0XFFE8E8E8), width: 1.5),
            borderRadius: const BorderRadius.all(Radius.circular(12)),
          ),
          child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: context.mqw * 0.90),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Radio(
                      activeColor: context.colorScheme.primary,
                      value: widget.value,
                      groupValue: widget.groupValue,
                      onChanged: widget.onChanged),
                  Expanded(
                    flex: 8,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16.0, bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          widget.title ?? const SizedBox.shrink(),
                          const SizedBox(
                            height: 2,
                          ),
                          widget.subtitle ?? const SizedBox.shrink(),
                        ],
                      ),
                    ),
                  ),
                  Expanded(child: SvgPicture.asset(AppAssets.edit)),
                  const SizedBox(
                    width: 8,
                  )
                ],
              ))),
    );
  }
}
