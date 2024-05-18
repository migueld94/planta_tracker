// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:flutter/material.dart';
// import 'package:ionicons/ionicons.dart';
// import 'package:portafolio/assets/utils/theme/themes_provider.dart';
// // import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import 'package:email_validator/email_validator.dart';

// class CardInfo extends StatelessWidget {
//   const CardInfo({
//     super.key,
//     required this.backgroundImage,
//     required this.textTitle,
//     required this.textBody,
//     required this.textButtom,
//     this.onTap,
//   });

//   final String backgroundImage;
//   final String textTitle;
//   final String textBody;
//   final String textButtom;
//   final void Function()? onTap;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 400,
//       height: 200,
//       decoration: BoxDecoration(
//         borderRadius: borderRadius10,
//         color: PortfolioColors.colorPrimary,
//         boxShadow: [
//           BoxShadow(
//             offset: const Offset(0, 3),
//             color: PortfolioColors.colorBlack.withOpacity(0.5),
//             blurRadius: 10,
//           )
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Row(
//           children: [
//             Container(
//               width: 150,
//               height: 230,
//               decoration: BoxDecoration(
//                 borderRadius: borderRadius5,
//                 image: DecorationImage(
//                   image: AssetImage(
//                     backgroundImage,
//                   ),
//                   fit: BoxFit.fill,
//                 ),
//               ),
//             ),
//             horizontalMargin8,
//             Expanded(
//               child: SizedBox(
//                 height: double.infinity,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     AutoSizeText(
//                       textTitle,
//                       style: context.theme.textTheme.h2,
//                     ),
//                     verticalMargin8,
//                     AutoSizeText(
//                       textBody,
//                       style: context.theme.textTheme.h4,
//                     ),
//                     const Expanded(child: emptyWidget),
//                     Material(
//                       color: PortfolioColors.colorTransparent,
//                       child: InkWell(
//                         onTap: onTap,
//                         child: Container(
//                           width: double.infinity,
//                           height: 40,
//                           decoration: BoxDecoration(
//                             borderRadius: borderRadius5,
//                             border: Border.all(
//                               color: PortfolioColors.colorBlack,
//                             ),
//                           ),
//                           child: Center(
//                             child: Text(
//                               textButtom,
//                               style: context.theme.textTheme.h5,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class CardInfoReverse extends StatelessWidget {
//   const CardInfoReverse({
//     super.key,
//     required this.backgroundImage,
//     required this.textTitle,
//     required this.textBody,
//     required this.textButtom,
//     this.onTap,
//   });

//   final String backgroundImage;
//   final String textTitle;
//   final String textBody;
//   final String textButtom;
//   final void Function()? onTap;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 400,
//       height: 200,
//       decoration: BoxDecoration(
//         borderRadius: borderRadius10,
//         color: PortfolioColors.colorPrimary,
//         boxShadow: [
//           BoxShadow(
//             offset: const Offset(0, 3),
//             color: PortfolioColors.colorBlack.withOpacity(0.5),
//             blurRadius: 10,
//           )
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Row(
//           children: [
//             Expanded(
//               child: SizedBox(
//                 height: double.infinity,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     AutoSizeText(
//                       textTitle,
//                       style: context.theme.textTheme.h2,
//                     ),
//                     verticalMargin8,
//                     AutoSizeText(
//                       textBody,
//                       style: context.theme.textTheme.h4,
//                     ),
//                     const Expanded(child: emptyWidget),
//                     Material(
//                       color: PortfolioColors.colorTransparent,
//                       child: InkWell(
//                         onTap: onTap,
//                         child: Container(
//                           width: double.infinity,
//                           height: 40,
//                           decoration: BoxDecoration(
//                             borderRadius: borderRadius5,
//                             border: Border.all(
//                               color: PortfolioColors.colorBlack,
//                             ),
//                           ),
//                           child: Center(
//                             child: Text(
//                               textButtom,
//                               textAlign: TextAlign.center,
//                               style: context.theme.textTheme.h5,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             horizontalMargin8,
//             Container(
//               width: 150,
//               height: 230,
//               decoration: BoxDecoration(
//                 borderRadius: borderRadius5,
//                 image: DecorationImage(
//                   image: AssetImage(
//                     backgroundImage,
//                   ),
//                   fit: BoxFit.fill,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class CardButtom extends StatelessWidget {
//   const CardButtom({
//     super.key,
//     required this.backgroundImage,
//     required this.textTitle,
//     this.onTap,
//   });

//   final String backgroundImage;
//   final String textTitle;
//   final void Function()? onTap;

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       child: InkWell(
//         onTap: onTap,
//         child: Container(
//           width: 400,
//           height: 90,
//           decoration: BoxDecoration(
//             borderRadius: borderRadius10,
//             color: PortfolioColors.colorPrimary,
//             boxShadow: [
//               BoxShadow(
//                 offset: const Offset(0, 3),
//                 color: PortfolioColors.colorBlack.withOpacity(0.5),
//                 blurRadius: 10,
//               )
//             ],
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 ClipOval(child: Image.asset(backgroundImage)),
//                 horizontalMargin12,
//                 Expanded(
//                   child: AutoSizeText(
//                     textTitle,
//                     style: context.theme.textTheme.h5,
//                   ),
//                 ),
//                 Icon(
//                   Ionicons.arrow_forward_outline,
//                   color: PortfolioColors.colorBlack,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class CardEmail extends StatefulWidget {
//   const CardEmail({
//     super.key,
//     required this.backgroundImage,
//     required this.textTitle,
//     required this.textBody,
//     required this.textButtom,
//   });

//   final String backgroundImage;
//   final String textTitle;
//   final String textBody;
//   final String textButtom;

//   @override
//   State<CardEmail> createState() => _CardEmailState();
// }

// class _CardEmailState extends State<CardEmail> {
//   String? nameValue;
//   String? emailValue;
//   String _errorMessage = '';
//   final formkey = GlobalKey<FormState>();

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 400,
//       decoration: BoxDecoration(
//         borderRadius: borderRadius10,
//         color: PortfolioColors.colorPrimary,
//         boxShadow: [
//           BoxShadow(
//             offset: const Offset(0, 3),
//             color: PortfolioColors.colorBlack.withOpacity(0.5),
//             blurRadius: 10,
//           )
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                   width: 150,
//                   height: 230,
//                   decoration: BoxDecoration(
//                     borderRadius: borderRadius5,
//                     image: DecorationImage(
//                       image: AssetImage(
//                         widget.backgroundImage,
//                       ),
//                       fit: BoxFit.fill,
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: SizedBox(
//                       height: 230,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           AutoSizeText(
//                             widget.textTitle,
//                             style: context.theme.textTheme.h2,
//                           ),
//                           verticalMargin8,
//                           AutoSizeText(
//                             widget.textBody,
//                             style: context.theme.textTheme.h4,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             AutoSizeText(
//               AppLocalizations.of(context)!.presentation_30,
//               style: context.theme.textTheme.h6,
//             ),
//             verticalMargin8,
//             Form(
//               key: formkey,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   TextFormField(
//                     onSaved: (newValue) {
//                       nameValue = newValue;
//                     },
//                     validator: (value) {
//                       if (value!.isEmpty) {
//                         return AppLocalizations.of(context)!.warning_00;
//                       }
//                       return null;
//                     },
//                     decoration: InputDecoration(
//                       errorStyle: TextStyle(
//                           color: PortfolioColors.colorRed, fontSize: 10.0),
//                       label: Text(
//                         AppLocalizations.of(context)!.presentation_31,
//                         style: context.theme.textTheme.h6.copyWith(
//                           color: PortfolioColors.colorGrey,
//                         ),
//                       ),
//                       border: const OutlineInputBorder(),
//                     ),
//                   ),
//                   verticalMargin12,
//                   TextFormField(
//                     keyboardType: TextInputType.emailAddress,
//                     decoration: InputDecoration(
//                       errorStyle: TextStyle(
//                           color: PortfolioColors.colorRed, fontSize: 10.0),
//                       label: Text(
//                         AppLocalizations.of(context)!.presentation_32,
//                         style: context.theme.textTheme.h6.copyWith(
//                           color: PortfolioColors.colorGrey,
//                         ),
//                       ),
//                       border: const OutlineInputBorder(),
//                     ),
//                     onChanged: (val) {
//                       validateEmail(val);
//                     },
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(left: 10.0, top: 8.0),
//                     child: Text(
//                       _errorMessage,
//                       style: TextStyle(
//                           color: PortfolioColors.colorRed, fontSize: 10.0),
//                     ),
//                   ),
//                   verticalMargin12,
//                   Material(
//                     color: PortfolioColors.colorTransparent,
//                     child: InkWell(
//                       onTap: () {
//                         if (formkey.currentState!.validate()) {
//                           formkey.currentState!.save();
//                         }
//                       },
//                       child: Container(
//                         width: double.infinity,
//                         height: 40,
//                         decoration: BoxDecoration(
//                           borderRadius: borderRadius5,
//                           border: Border.all(
//                             color: PortfolioColors.colorBlack,
//                           ),
//                         ),
//                         child: Center(
//                           child: Text(
//                             widget.textButtom,
//                             style: context.theme.textTheme.h5,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void validateEmail(String val) {
//     if (val.isEmpty) {
//       setState(() {
//         _errorMessage = AppLocalizations.of(context)!.warning_01;
//       });
//     } else if (!EmailValidator.validate(val, true)) {
//       setState(() {
//         _errorMessage = AppLocalizations.of(context)!.warning_02;
//       });
//     } else {
//       setState(() {
//         _errorMessage = "";
//       });
//     }
//   }
// }

// class SectionForm extends StatefulWidget {
//   const SectionForm({
//     super.key,
//     required this.textTitle,
//     required this.textBody,
//     required this.textButtom,
//     required this.nameForm,
//     required this.emailForm,
//     required this.colorButtom,
//     required this.widthButtom,
//     required this.backgroundColor,
//   });

//   final String textTitle;
//   final String textBody;
//   final String textButtom;
//   final String nameForm;
//   final String emailForm;
//   final Color colorButtom;
//   final Color backgroundColor;
//   final double widthButtom;

//   @override
//   State<SectionForm> createState() => _SectionFormState();
// }

// class _SectionFormState extends State<SectionForm> {
//   String? nameValue;
//   String? emailValue;
//   String _errorMessage = '';
//   final formkey = GlobalKey<FormState>();

//   @override
//   Widget build(BuildContext context) {
//     final currentWidth = MediaQuery.of(context).size;
//     return Container(
//       height: currentWidth.height,
//       color: widget.backgroundColor,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 170.0, vertical: 50.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             AutoSizeText(
//               widget.textTitle,
//               // 'Master Resell Rights',
//               textAlign: TextAlign.center,
//               style: context.theme.textTheme.header,
//             ),
//             AutoSizeText(
//               widget.textBody,
//               textAlign: TextAlign.center,
//               style: context.theme.textTheme.h4,
//             ),
//             Form(
//               key: formkey,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   TextFormField(
//                     onSaved: (newValue) {
//                       nameValue = newValue;
//                     },
//                     validator: (value) {
//                       if (value!.isEmpty) {
//                         return AppLocalizations.of(context)!.warning_00;
//                       }
//                       return null;
//                     },
//                     decoration: InputDecoration(
//                       errorStyle: TextStyle(
//                           color: PortfolioColors.colorRed, fontSize: 10.0),
//                       label: Text(
//                         widget.nameForm,
//                         style: context.theme.textTheme.h6.copyWith(
//                           color: PortfolioColors.colorGrey,
//                         ),
//                       ),
//                       border: const OutlineInputBorder(
//                         borderRadius: borderRadius5,
//                       ),
//                     ),
//                   ),
//                   verticalMargin30,
//                   TextFormField(
//                     decoration: InputDecoration(
//                       errorStyle: TextStyle(
//                           color: PortfolioColors.colorRed, fontSize: 10.0),
//                       label: Text(
//                         widget.emailForm,
//                         style: context.theme.textTheme.h6.copyWith(
//                           color: PortfolioColors.colorGrey,
//                         ),
//                       ),
//                       border: const OutlineInputBorder(
//                         borderRadius: borderRadius5,
//                       ),
//                     ),
//                     onChanged: (val) {
//                       validateEmail(val);
//                     },
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(left: 10.0, top: 8.0),
//                     child: Text(
//                       _errorMessage,
//                       style: TextStyle(
//                           color: PortfolioColors.colorRed, fontSize: 10.0),
//                     ),
//                   ),
//                   verticalMargin12,
//                   Center(
//                     child: Material(
//                       color: PortfolioColors.colorTransparent,
//                       child: InkWell(
//                         onTap: () {
//                           if (formkey.currentState!.validate()) {
//                             formkey.currentState!.save();
//                           }
//                         },
//                         child: Container(
//                           width: widget.widthButtom,
//                           height: 60,
//                           decoration: BoxDecoration(
//                             borderRadius: borderRadius5,
//                             color: widget.colorButtom,
//                           ),
//                           child: Center(
//                             child: Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Text(
//                                 widget.textButtom,
//                                 textAlign: TextAlign.center,
//                                 style: context.theme.textTheme.h6.copyWith(
//                                   color: PortfolioColors.colorWhite,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             RichText(
//               text: TextSpan(
//                 children: [
//                   TextSpan(
//                     text: AppLocalizations.of(context)!.presentation_33,
//                     style: context.theme.textTheme.h5.copyWith(
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   TextSpan(
//                     text: 'flodesk',
//                     style: context.theme.textTheme.h5.copyWith(
//                       fontWeight: FontWeight.bold,
//                       decoration: TextDecoration.underline,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void validateEmail(String val) {
//     if (val.isEmpty) {
//       setState(() {
//         _errorMessage = AppLocalizations.of(context)!.warning_01;
//       });
//     } else if (!EmailValidator.validate(val, true)) {
//       setState(() {
//         _errorMessage = AppLocalizations.of(context)!.warning_02;
//       });
//     } else {
//       setState(() {
//         _errorMessage = "";
//       });
//     }
//   }
// }
