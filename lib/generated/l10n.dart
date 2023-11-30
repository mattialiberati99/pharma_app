// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Pharma!`
  String get onboarding_title_01 {
    return Intl.message(
      'Pharma!',
      name: 'onboarding_title_01',
      desc: '',
      args: [],
    );
  }

  /// `Ecco tutto ciò che vuoi in un \nbattibaleno`
  String get onboarding_subtitle_01 {
    return Intl.message(
      'Ecco tutto ciò che vuoi in un \nbattibaleno',
      name: 'onboarding_subtitle_01',
      desc: '',
      args: [],
    );
  }

  /// `Press the Back button again to exit the app`
  String get snack_text {
    return Intl.message(
      'Press the Back button again to exit the app',
      name: 'snack_text',
      desc: '',
      args: [],
    );
  }

  /// `Ben tornato!\nSiamo felici \ndi rivederti!`
  String get login_title {
    return Intl.message(
      'Ben tornato!\nSiamo felici \ndi rivederti!',
      name: 'login_title',
      desc: '',
      args: [],
    );
  }

    /// `Oppure entra con`
  String get or_login_with {
    return Intl.message(
      'Oppure entra con',
      name: 'or_login_with',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Salta`
  String get skip {
    return Intl.message(
      'Salta',
      name: 'skip',
      desc: '',
      args: [],
    );
  }

  /// `Password dimenticata?`
  String get forgot_password {
    return Intl.message(
      'Password dimenticata?',
      name: 'forgot_password',
      desc: '',
      args: [],
    );
  }

  /// `Invia link`
  String get send_password_reset_link {
    return Intl.message(
      'Invia link',
      name: 'send_password_reset_link',
      desc: '',
      args: [],
    );
  }

  /// `Mi ricordo la password, login`
  String get i_remember_my_password_return_to_login {
    return Intl.message(
      'Mi ricordo la password, login',
      name: 'i_remember_my_password_return_to_login',
      desc: '',
      args: [],
    );
  }

  // `Email per resettare la password`
  String get email_to_reset_password {
    return Intl.message(
      'Email per resettare la password',
      name: 'email_to_reset_password',
      desc: '',
      args: [],
    );
  }

  /// `Registrati`
  String get signup {
    return Intl.message(
      'Registrati',
      name: 'signup',
      desc: '',
      args: [],
    );
  }

  /// `Email o password sbagliati`
  String get wrong_email_or_password {
    return Intl.message(
      'Email o password sbagliati',
      name: 'wrong_email_or_password',
      desc: '',
      args: [],
    );
  }

  /// `Account esistente`
  String get this_email_account_exists {
    return Intl.message(
      'Account esistente',
      name: 'this_email_account_exists',
      desc: '',
      args: [],
    );
  }

  /// `L'account non esiste`
  String get this_account_not_exist {
    return Intl.message(
      'L\'account non esiste',
      name: 'this_account_not_exist',
      desc: '',
      args: [],
    );
  }

  /// `Errore! Controlla impostazioni email`
  String get error_verify_email_settings {
    return Intl.message(
      'Errore! Controlla impostazioni email',
      name: 'error_verify_email_settings',
      desc: '',
      args: [],
    );
  }

  /// `Accedendo accetti la`
  String get by_signin_accept {
    return Intl.message(
      'Accedendo accetti la',
      name: 'by_signin_accept',
      desc: '',
      args: [],
    );
  }

  /// `Privacy Policy`
  String get privacy_policy {
    return Intl.message(
      'Privacy Policy',
      name: 'privacy_policy',
      desc: '',
      args: [],
    );
  }

  /// `Hai bisogno di una risposta al più presto? Chiama il numero gratuito 800400400 disponibileh 24, 7 giorni su 7!`
  String get contact_text1 {
    return Intl.message(
      'Hai bisogno di una risposta al più presto? Chiama il numero gratuito 800400400 disponibileh 24, 7 giorni su 7!',
      name: 'contact_text1',
      desc: '',
      args: [],
    );
  }

  /// `Puoi inviarci un messaggio di testo facendo clic sul bottone qui sotto. Non è richiesto il consenso per nessun acquisto. Potrebbero essere applicate tariffe per messaggi e dati.`
  String get contact_text2 {
    return Intl.message(
      'Puoi inviarci un messaggio di testo facendo clic sul bottone qui sotto. Non è richiesto il consenso per nessun acquisto. Potrebbero essere applicate tariffe per messaggi e dati.',
      name: 'contact_text2',
      desc: '',
      args: [],
    );
  }

  /// `CHIAMA IL NUMERO VERDE`
  String get contact_btn1 {
    return Intl.message(
      'CHIAMA IL NUMERO VERDE',
      name: 'contact_btn1',
      desc: '',
      args: [],
    );
  }

  /// `INVIA EMAIL`
  String get contact_btn2 {
    return Intl.message(
      'INVIA EMAIL',
      name: 'contact_btn2',
      desc: '',
      args: [],
    );
  }

  /// `Vuoi diventare partner di Tac?\nNoi ci impegniamo a darti ottime soluzioni e tutti i supporti utili alla crescita della tua attività.\nTi proponiamo una partnership basata su etica professionale, chiarezza contrattuale, incentivi definiti, margini certi e condivisione di strumenti.\nCosa aspetti?`
  String get partner_text {
    return Intl.message(
      'Vuoi diventare partner di Tac?\nNoi ci impegniamo a darti ottime soluzioni e tutti i supporti utili alla crescita della tua attività.\nTi proponiamo una partnership basata su etica professionale, chiarezza contrattuale, incentivi definiti, margini certi e condivisione di strumenti.\nCosa aspetti?',
      name: 'partner_text',
      desc: '',
      args: [],
    );
  }

  /// `INVIA RICHIESTA`
  String get partner_btn {
    return Intl.message(
      'INVIA RICHIESTA',
      name: 'partner_btn',
      desc: '',
      args: [],
    );
  }

  /// `Scegli tu dove e quando guadagnare utilizzando il mezzo che vuoi, scooter, bici o auto.`
  String get work_how {
    return Intl.message(
      'Scegli tu dove e quando guadagnare utilizzando il mezzo che vuoi, scooter, bici o auto.',
      name: 'work_how',
      desc: '',
      args: [],
    );
  }

  /// `Realizza i tuoi obiettivi di guadagno`
  String get work_gain {
    return Intl.message(
      'Realizza i tuoi obiettivi di guadagno',
      name: 'work_gain',
      desc: '',
      args: [],
    );
  }

  /// `Ricevi supporto in qualsiasi momento`
  String get work_support {
    return Intl.message(
      'Ricevi supporto in qualsiasi momento',
      name: 'work_support',
      desc: '',
      args: [],
    );
  }

  /// `Cosa ti serve per lavorare con noi?`
  String get work_need {
    return Intl.message(
      'Cosa ti serve per lavorare con noi?',
      name: 'work_need',
      desc: '',
      args: [],
    );
  }

  /// `Bicicletta, scooter o auto\n(con patente e assicurazione)`
  String get work_vehicles {
    return Intl.message(
      'Bicicletta, scooter o auto\n(con patente e assicurazione)',
      name: 'work_vehicles',
      desc: '',
      args: [],
    );
  }

  /// `Smartphone con sistema operativo iOS 13.6, Android 6.0 o successivo`
  String get work_devices {
    return Intl.message(
      'Smartphone con sistema operativo iOS 13.6, Android 6.0 o successivo',
      name: 'work_devices',
      desc: '',
      args: [],
    );
  }

  /// `Permesso di lavorare in Italia come lavoratore autonomo`
  String get work_permission {
    return Intl.message(
      'Permesso di lavorare in Italia come lavoratore autonomo',
      name: 'work_permission',
      desc: '',
      args: [],
    );
  }

  /// `Essere maggiorenne`
  String get work_age {
    return Intl.message(
      'Essere maggiorenne',
      name: 'work_age',
      desc: '',
      args: [],
    );
  }

  /// `CANDIDATI SUBITO`
  String get work_apply {
    return Intl.message(
      'CANDIDATI SUBITO',
      name: 'work_apply',
      desc: '',
      args: [],
    );
  }

  /// `Condividendo questo QR code con i tuoi contatti, tu riceverai in regalo uno sconto di€ 5,00 sul prossimo acquisto.Cosa aspetti? Inizia ora!`
  String get share_text {
    return Intl.message(
      'Condividendo questo QR code con i tuoi contatti, tu riceverai in regalo uno sconto di€ 5,00 sul prossimo acquisto.Cosa aspetti? Inizia ora!',
      name: 'share_text',
      desc: '',
      args: [],
    );
  }

  /// `INVIA QR CODE`
  String get share_btn {
    return Intl.message(
      'INVIA QR CODE',
      name: 'share_btn',
      desc: '',
      args: [],
    );
  }

  /// `COSA VORRESTI \nOGGI?`
  String get pre_home_title {
    return Intl.message(
      'COSA VORRESTI \nOGGI?',
      name: 'pre_home_title',
      desc: '',
      args: [],
    );
  }

  /// `Ciao! Registrati prima di \ncontinuare`
  String get signup_title {
    return Intl.message(
      'Ciao! Registrati prima di \ncontinuare',
      name: 'signup_title',
      desc: '',
      args: [],
    );
  }

  /// `Inserire email valida`
  String get should_be_a_valid_email {
    return Intl.message(
      'Inserire email valida',
      name: 'should_be_a_valid_email',
      desc: '',
      args: [],
    );
  }

  /// `Più di 3 caratteri richiesti`
  String get should_be_more_than_3_letters {
    return Intl.message(
      'Più di 3 caratteri richiesti',
      name: 'should_be_more_than_3_letters',
      desc: '',
      args: [],
    );
  }

  /// `Almeno 6 caratteri richiesti`
  String get should_be_more_than_6_letters {
    return Intl.message(
      'Almeno 6 caratteri richiesti',
      name: 'should_be_more_than_6_letters',
      desc: '',
      args: [],
    );
  }

  /// `"Le password non corrispondono"`
  String get password_not_match {
    return Intl.message(
      '"Le password non corrispondono"',
      name: 'password_not_match',
      desc: '',
      args: [],
    );
  }

  /// `Permesso mancante`
  String get permission_denied {
    return Intl.message(
      'Permesso mancante',
      name: 'permission_denied',
      desc: '',
      args: [],
    );
  }

  /// `Abilita localizzazione`
  String get enable_localisation {
    return Intl.message(
      'Abilita localizzazione',
      name: 'enable_localisation',
      desc: '',
      args: [],
    );
  }

  /// `Abilita notifiche`
  String get enable_notifications {
    return Intl.message(
      'Abilita notifiche',
      name: 'enable_notifications',
      desc: '',
      args: [],
    );
  }

  /// `Conferma`
  String get confirmation {
    return Intl.message(
      'Conferma',
      name: 'confirmation',
      desc: '',
      args: [],
    );
  }

  /// `ORDINA I PRODOTTI PER`
  String get action_btn_order {
    return Intl.message(
      'ORDINA I PRODOTTI PER',
      name: 'action_btn_order',
      desc: '',
      args: [],
    );
  }

  /// `ANNULLA`
  String get action_btn_cancel {
    return Intl.message(
      'ANNULLA',
      name: 'action_btn_cancel',
      desc: '',
      args: [],
    );
  }

  /// `Se raggiungi i € 10 la consegna è gratis`
  String get action_free_delivery {
    return Intl.message(
      'Se raggiungi i € 10 la consegna è gratis',
      name: 'action_free_delivery',
      desc: '',
      args: [],
    );
  }

  /// `ORDINA`
  String get action_order {
    return Intl.message(
      'ORDINA',
      name: 'action_order',
      desc: '',
      args: [],
    );
  }

  /// `APPLICA`
  String get action_apply {
    return Intl.message(
      'APPLICA',
      name: 'action_apply',
      desc: '',
      args: [],
    );
  }

  /// `AGGIUNGI PER`
  String get action_btn_add {
    return Intl.message(
      'AGGIUNGI PER',
      name: 'action_btn_add',
      desc: '',
      args: [],
    );
  }

  /// `TORNA AL MENU'`
  String get action_btn_back_to_menu {
    return Intl.message(
      'TORNA AL MENU\'',
      name: 'action_btn_back_to_menu',
      desc: '',
      args: [],
    );
  }

  /// `Carrello`
  String get cart_title {
    return Intl.message(
      'Carrello',
      name: 'cart_title',
      desc: '',
      args: [],
    );
  }

  /// `Conferma Eliminazione`
  String get dialog_title {
    return Intl.message(
      'Conferma Eliminazione',
      name: 'dialog_title',
      desc: '',
      args: [],
    );
  }

  /// `Sei sicuro di voler eliminare questo prodotto dal carrello?`
  String get dialog_subtitle {
    return Intl.message(
      'Sei sicuro di voler eliminare questo prodotto dal carrello?',
      name: 'dialog_subtitle',
      desc: '',
      args: [],
    );
  }

  String get dialog_subtitle_address {
    return Intl.message('Sei sicuro di voeler eliminare questo indirizzo?',
        name: 'dialog_subtitle_address', desc: '', args: []);
  }

  /// `Sei sicuro di voler eliminare questa carta di credito?`
  String get dialog_subtitle_card {
    return Intl.message(
      'Sei sicuro di voler eliminare questa carta di credito?',
      name: 'dialog_subtitle_card',
      desc: '',
      args: [],
    );
  }

  /// `ELIMINA`
  String get dialog_delete {
    return Intl.message(
      'ELIMINA',
      name: 'dialog_delete',
      desc: '',
      args: [],
    );
  }

  /// `ANNULLA`
  String get dialog_cancel {
    return Intl.message(
      'ANNULLA',
      name: 'dialog_cancel',
      desc: '',
      args: [],
    );
  }

  /// `Titolare carta`
  String get card_holder {
    return Intl.message(
      'Titolare carta',
      name: 'card_holder',
      desc: '',
      args: [],
    );
  }

  /// `Numero carta`
  String get card_number {
    return Intl.message(
      'Numero carta',
      name: 'card_number',
      desc: '',
      args: [],
    );
  }

  /// `Data di scadenza`
  String get exp_date {
    return Intl.message(
      'Data di scadenza',
      name: 'exp_date',
      desc: '',
      args: [],
    );
  }

  /// `CVC`
  String get cvc {
    return Intl.message(
      'CVC',
      name: 'cvc',
      desc: '',
      args: [],
    );
  }

  /// `Salva carta`
  String get save_card {
    return Intl.message(
      'Salva carta',
      name: 'save_card',
      desc: '',
      args: [],
    );
  }

  /// `NUOVA CARTA`
  String get card_new {
    return Intl.message(
      'NUOVA CARTA',
      name: 'card_new',
      desc: '',
      args: [],
    );
  }

  /// `Non hai nessun articolo nel carrello`
  String get empty_cart {
    return Intl.message(
      'Non hai nessun articolo nel carrello',
      name: 'empty_cart',
      desc: '',
      args: [],
    );
  }

  /// `Opzioni di pagamento`
  String get payment_options {
    return Intl.message(
      'Opzioni di pagamento',
      name: 'payment_options',
      desc: '',
      args: [],
    );
  }

  /// `Contanti`
  String get cash_on_delivery {
    return Intl.message(
      'Contanti',
      name: 'cash_on_delivery',
      desc: '',
      args: [],
    );
  }

  /// `Carta di credito`
  String get visa_card {
    return Intl.message(
      'Carta di credito',
      name: 'visa_card',
      desc: '',
      args: [],
    );
  }

  /// `MasterCard`
  String get mastercard {
    return Intl.message(
      'MasterCard',
      name: 'mastercard',
      desc: '',
      args: [],
    );
  }

  /// `PayPal`
  String get paypal {
    return Intl.message(
      'PayPal',
      name: 'paypal',
      desc: '',
      args: [],
    );
  }

  /// `Ritiro in negozio`
  String get pay_on_pickup {
    return Intl.message(
      'Ritiro in negozio',
      name: 'pay_on_pickup',
      desc: '',
      args: [],
    );
  }

  /// `Paga con carta di credito`
  String get click_to_pay_with_your_visa_card {
    return Intl.message(
      'Paga con carta di credito',
      name: 'click_to_pay_with_your_visa_card',
      desc: '',
      args: [],
    );
  }

  /// `Click to pay with your MasterCard`
  String get click_to_pay_with_your_mastercard {
    return Intl.message(
      'Click to pay with your MasterCard',
      name: 'click_to_pay_with_your_mastercard',
      desc: '',
      args: [],
    );
  }

  /// `Paga con PayPal`
  String get click_to_pay_with_your_paypal_account {
    return Intl.message(
      'Paga con PayPal',
      name: 'click_to_pay_with_your_paypal_account',
      desc: '',
      args: [],
    );
  }

  /// `Paga contanti alla consegna`
  String get click_to_pay_cash_on_delivery {
    return Intl.message(
      'Paga contanti alla consegna',
      name: 'click_to_pay_cash_on_delivery',
      desc: '',
      args: [],
    );
  }

  /// `Paga al ritiro`
  String get click_to_pay_on_pickup {
    return Intl.message(
      'Paga al ritiro',
      name: 'click_to_pay_on_pickup',
      desc: '',
      args: [],
    );
  }

  /// `In sede`
  String get in_struttura {
    return Intl.message(
      'In sede',
      name: 'in_struttura',
      desc: '',
      args: [],
    );
  }

  /// `Cerca via, città, quartiere...`
  String get search_address_hint {
    return Intl.message(
      'Cerca via, città, quartiere...',
      name: 'search_address_hint',
      desc: '',
      args: [],
    );
  }

  /// `Indirizzo`
  String get address {
    return Intl.message(
      'Indirizzo',
      name: 'address',
      desc: '',
      args: [],
    );
  }

  /// `Indirizzo di consegna`
  String get delivery_address {
    return Intl.message(
      'Indirizzo di consegna',
      name: 'delivery_address',
      desc: '',
      args: [],
    );
  }

  /// `Aggiungi indirizzo`
  String get add_new_delivery_address {
    return Intl.message(
      'Aggiungi indirizzo',
      name: 'add_new_delivery_address',
      desc: '',
      args: [],
    );
  }

  /// `Modifica recapito`
  String get update_recapito {
    return Intl.message(
      'Modifica recapito',
      name: 'update_recapito',
      desc: '',
      args: [],
    );
  }

  /// `Nome`
  String get name {
    return Intl.message(
      'Nome',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `Descrizione locale`
  String get description {
    return Intl.message(
      'Descrizione locale',
      name: 'description',
      desc: '',
      args: [],
    );
  }

  /// `Non hai nessuna notifica`
  String get dont_have_any_item_in_the_notification_list {
    return Intl.message(
      'Non hai nessuna notifica',
      name: 'dont_have_any_item_in_the_notification_list',
      desc: '',
      args: [],
    );
  }

  /// `PayPal Payment`
  String get paypal_payment {
    return Intl.message(
      'PayPal Payment',
      name: 'paypal_payment',
      desc: '',
      args: [],
    );
  }

  /// `Devi accedere per vedere questa sezione`
  String get you_must_signin_to_access_to_this_section {
    return Intl.message(
      'Devi accedere per vedere questa sezione',
      name: 'you_must_signin_to_access_to_this_section',
      desc: '',
      args: [],
    );
  }

  /// `Accedi`
  String get login {
    return Intl.message(
      'Accedi',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Vuoi eliminare la chat?`
  String get delete_chat {
    return Intl.message(
      'Vuoi eliminare la chat?',
      name: 'delete_chat',
      desc: '',
      args: [],
    );
  }

  /// `Verrà eliminata per entrambi i partecipanti e non potrà più essere recuperata.`
  String get eliminated_for_both {
    return Intl.message(
      'Verrà eliminata per entrambi i partecipanti e non potrà più essere recuperata.',
      name: 'eliminated_for_both',
      desc: '',
      args: [],
    );
  }

  /// `Segnala Utente`
  String get report_user {
    return Intl.message(
      'Segnala Utente',
      name: 'report_user',
      desc: '',
      args: [],
    );
  }

  /// `Blocca Utente`
  String get block_user {
    return Intl.message(
      'Blocca Utente',
      name: 'block_user',
      desc: '',
      args: [],
    );
  }

  /// `Invia il primo messaggio a \n{user}`
  String send_first_message(Object user) {
    return Intl.message(
      'Invia il primo messaggio a \n$user',
      name: 'send_first_message',
      desc: '',
      args: [user],
    );
  }

  /// `Scrivi un messaggio`
  String get typeToStartChat {
    return Intl.message(
      'Scrivi un messaggio',
      name: 'typeToStartChat',
      desc: '',
      args: [],
    );
  }

  /// `Non hai un account?`
  String get i_dont_have_an_account {
    return Intl.message(
      'Non hai un account?',
      name: 'i_dont_have_an_account',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'it'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
