import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_app/src/helpers/extensions.dart';
import 'package:pharma_app/src/pages/profile/widget/profile_app_bar.dart';
import 'package:pharma_app/src/providers/addresses_provider.dart';

import '../../components/footer_actions.dart';
import '../../components/selector.dart';
import '../../helpers/app_config.dart';
import '../../repository/paymentCards_repository.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final PageController _pageController = PageController(initialPage: 0);
  int currentStep = 0;

  void onItemTap(int index) {
    _pageController.jumpToPage(
      index,
    );

    setState(() {
      currentStep = index;
    });
  }

  void onPageChanged(int val) {
    setState(() {
      currentStep = val;
    });
  }

  @override
  void initState() {
    _loadCards();
    super.initState();
  }

  _loadCards() async {
    await getUserCreditCards();
    print('CREDIT CARDS LOADED [PROFILE]- ${cards.length.toString()}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ProfileAppBar(
        title: "Profilo",
      ),
      extendBody: true,
      extendBodyBehindAppBar: true,
      bottomNavigationBar: Stack(
        children: [
          Consumer(builder: (context, ref, _) {
            return Visibility(
              visible: currentStep == 1,
              child: FooterActions(
                firstLabel: "AGGIUNGI INDIRIZZO +", //TODO stringhe
                firstAction: () {
                  Navigator.of(context).pushNamed('SearchAddress');
                  ref.refresh(addressesProvider);
                },
                hasSecond: false,
              ),
            );
          }),
          Visibility(
            visible: currentStep == 3,
            child: FooterActions(
              firstLabel: "AGGIUNGI CARTA +", //TODO stringhe
              firstAction: () =>
                  Navigator.of(context).pushNamed('GestisciCarte'),
              hasSecond: false,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: context.mqw * 0.08),
            child: Column(
              children: [
                SectionSelector(
                  currentIndex: currentStep,
                  onItemTap: onItemTap,
                ),
                const SizedBox(
                  height: 30,
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: context.mqw * 0.90,
                    maxHeight: 390,
                  ),
                  child: PageView(
                    onPageChanged: onPageChanged,
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: List.generate(ProfileSections.values.length,
                        (index) => ProfileSections.values[index].content),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SectionSelector extends StatefulWidget {
  /// This holds the index we're at.
  final int currentIndex;

  /// A callback for when the user taps on the dot.
  final Function(int) onItemTap;

  const SectionSelector({
    Key? key,
    required this.currentIndex,
    required this.onItemTap,
  }) : super(key: key);

  @override
  State<SectionSelector> createState() => _SectionSelectorState();
}

class _SectionSelectorState extends State<SectionSelector> {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: context.mqh * 0.33,
        maxWidth: context.mqw * 0.90,
      ),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 45),
        itemCount: ProfileSections.values.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 15,
            crossAxisSpacing: 15,
            childAspectRatio: 1.2),
        itemBuilder: (BuildContext context, int index) => Selector(
          index: index,
          currentScreen: widget.currentIndex == index,
          onTap: () => widget.onItemTap(index),
        ),
      ),
    );
  }
}
