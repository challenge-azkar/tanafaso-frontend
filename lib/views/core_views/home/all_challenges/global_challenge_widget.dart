import 'package:auto_size_text/auto_size_text.dart';
import 'package:azkar/models/challenge.dart';
import 'package:azkar/models/global_challenge.dart';
import 'package:azkar/services/service_provider.dart';
import 'package:azkar/utils/app_localizations.dart';
import 'package:azkar/utils/features.dart';
import 'package:azkar/views/core_views/home/all_challenges/challenge_list_item_loading_widget.dart';
import 'package:azkar/views/core_views/home/do_challenge/do_global_challenge/do_global_challenge_screen.dart';
import 'package:azkar/views/core_views/home/home_main_screen.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';

class GlobalChallengeWidget extends StatefulWidget {
  final ReloadHomeMainScreenCallback reloadHomeMainScreenCallback;

  GlobalChallengeWidget({required this.reloadHomeMainScreenCallback});

  @override
  State<GlobalChallengeWidget> createState() => _GlobalChallengeWidgetState();
}

class _GlobalChallengeWidgetState extends State<GlobalChallengeWidget>
    with SingleTickerProviderStateMixin {
  late GlobalChallenge _globalChallenge;
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  Future<void> getNeededData() async {
    _globalChallenge =
        await ServiceProvider.challengesService.getGlobalChallenge();
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(1.5, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticIn,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getNeededData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              !snapshot.hasError &&
              _globalChallenge.challenge.challengeType == ChallengeType.AZKAR) {
            return SafeArea(
              child: Banner(
                message: 'جديد',
                location: BannerLocation.topEnd,
                textStyle: TextStyle(fontSize: 20),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: RawMaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.all(4),
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DoGlobalChallengeScreen(
                                  globalChallenge: _globalChallenge,
                                  reloadHomeMainScreenCallback:
                                      widget.reloadHomeMainScreenCallback,
                                ))),
                    elevation: 3.0,
                    fillColor: Colors.white,
                    child: DescribedFeatureOverlay(
                      key: Key(Features.GLOBAL_CHALLENGE),
                      featureId: Features.GLOBAL_CHALLENGE,
                      overflowMode: OverflowMode.wrapBackground,
                      contentLocation: ContentLocation.below,
                      barrierDismissible: false,
                      backgroundDismissible: false,
                      tapTarget: Icon(Icons.public),
                      // The widget that will be displayed as the tap target.
                      title: Center(
                        child: Row(
                          children: [
                            Expanded(
                              child: FittedBox(
                                child: Text(
                                    AppLocalizations.of(context)
                                        .globalChallengeFeature,
                                    softWrap: true,
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontSize: 25,
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                      description: Row(
                        children: [
                          Expanded(
                            child: Text(
                                AppLocalizations.of(context)
                                    .globalChallengeFeatureDescription,
                                softWrap: true,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20,
                                )),
                          ),
                        ],
                      ),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      targetColor: Colors.white,
                      textColor: Colors.black,
                      child: Column(
                        children: [
                          Text(
                            AppLocalizations.of(context).globalChallenge,
                            style: TextStyle(
                                fontSize: 35, fontWeight: FontWeight.bold),
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Padding(padding: EdgeInsets.only(right: 8)),
                                Expanded(
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    alignment: Alignment.center,
                                    child: Text(
                                      _globalChallenge
                                          .challenge.azkarChallenge!.name!,
                                      style: TextStyle(fontSize: 35),
                                      maxLines: 1,
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                Padding(padding: EdgeInsets.only(right: 8)),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 8,
                            ),
                            child: Visibility(
                              visible: (((_globalChallenge.challenge
                                              .azkarChallenge?.motivation ??
                                          "")
                                      .length) !=
                                  0),
                              child: AutoSizeText(
                                _globalChallenge
                                        .challenge.azkarChallenge?.motivation ??
                                    "",
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                                maxLines: 3,
                                style: TextStyle(fontSize: 25),
                                textAlign: TextAlign.center,
                                minFontSize: 25,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Text.rich(
                              TextSpan(
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 25,
                                ),
                                children: <TextSpan>[
                                  new TextSpan(
                                    text: 'أُنهي ',
                                    style: new TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  new TextSpan(
                                    text: _globalChallenge.finishedCount
                                        .toString(),
                                    style: new TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  new TextSpan(
                                    text: ' مرة',
                                    style: new TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Container();
          } else {
            return ChallengeListItemLoadingWidget();
          }
        });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
