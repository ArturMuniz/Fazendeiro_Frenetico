extends Node
## Poing Studios v5.1.0 adapter. Only loaded with the native Android singleton.
signal available
signal shown(token: int)
signal earned(token: int)
signal closed(token: int)
signal failed(token: int, message: String)
const TEST_UNIT := "ca-app-pub-3940256099942544/5224354917"
var _ad: RewardedAd
var _token: int = 0
var _initialized: bool = false

func start() -> void:
	var params := ConsentRequestParameters.new()
	UserMessagingPlatform.consent_information.update(params, _consent_updated, _consent_failed)

func _consent_updated() -> void:
	var info := UserMessagingPlatform.consent_information
	if info.get_consent_status() == ConsentInformation.ConsentStatus.REQUIRED and info.get_is_consent_form_available():
		UserMessagingPlatform.load_consent_form(func(form: ConsentForm) -> void:
			form.show(func(_error: FormError) -> void: _initialize_if_allowed()), _consent_failed)
	else:
		_initialize_if_allowed()

func _consent_failed(_error: FormError) -> void:
	_initialize_if_allowed()

func _initialize_if_allowed() -> void:
	var status := UserMessagingPlatform.consent_information.get_consent_status()
	if status not in [ConsentInformation.ConsentStatus.NOT_REQUIRED, ConsentInformation.ConsentStatus.OBTAINED]:
		return
	if _initialized:
		available.emit()
		return
	var listener := OnInitializationCompleteListener.new()
	listener.on_initialization_complete = func(_status: InitializationStatus) -> void:
		_initialized = true
		available.emit()
	MobileAds.initialize(listener)

func show_rewarded(token: int) -> void:
	_token = token
	var unit := TEST_UNIT
	# Safe default for all builds until production IDs are explicitly configured.
	if not bool(ProjectSettings.get_setting("game_ads/test_mode", true)) and not OS.is_debug_build():
		unit = str(ProjectSettings.get_setting("game_ads/rewarded_unit_id", ""))
		if unit.is_empty():
			failed.emit(token, "Unidade de anúncio não configurada.")
			return
	var callback := RewardedAdLoadCallback.new()
	callback.on_ad_failed_to_load = func(_error: LoadAdError) -> void:
		if _token == token: failed.emit(token, "Não há anúncio disponível. Tente novamente mais tarde.")
	callback.on_ad_loaded = func(ad: RewardedAd) -> void:
		if _token != token:
			ad.destroy()
			return
		_ad = ad
		var fullscreen := FullScreenContentCallback.new()
		fullscreen.on_ad_showed_full_screen_content = func() -> void: shown.emit(token)
		fullscreen.on_ad_dismissed_full_screen_content = func() -> void: closed.emit(token)
		fullscreen.on_ad_failed_to_show_full_screen_content = func(_error: AdError) -> void:
			failed.emit(token, "Não foi possível abrir o anúncio.")
		_ad.full_screen_content_callback = fullscreen
		var reward := OnUserEarnedRewardListener.new()
		reward.on_user_earned_reward = func(_item: RewardedItem) -> void: earned.emit(token)
		_ad.show(reward)
	RewardedAdLoader.new().load(unit, AdRequest.new(), callback)

func cancel(token: int) -> void:
	if token != _token:
		return
	_token = 0
	if _ad != null:
		_ad.destroy()
		_ad = null

func show_privacy_options() -> void:
	UserMessagingPlatform.show_privacy_options_form(func(_error: FormError) -> void: pass)
