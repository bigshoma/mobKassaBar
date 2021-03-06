
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	НаборКонстант = Константы.СоздатьНабор(СписокКонстант());
	НаборКонстант.Прочитать();
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, НаборКонстант, СписокКонстант());
	
	НастроитьФормуПоЗначениямНастроек();
	
	// АдминистративныйРежим
	ОбщегоНазначения.НастроитьФормуПоАдминистративномуРежиму(ЭтотОбъект);
	
	Если ЗначениеЗаполнено(ОборудованиеПечати) Тогда
		ДрайверУстройстваПечати = ОборудованиеПечати.ДрайверОборудования;
		ТипОборудования = ОборудованиеПечати.ТипОборудования;
	КонецЕсли;
	
	НастроитьВидимостьУстройстваПечати();
	
	ОпределитьПараметрыДрайвера();
	
	// ОриентацияЭкрана
	НастроитьФормуПоОриентацииЭкрана();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	// АдминистративныйРежим
	НастроитьДоступностьЭлементовПоАдминистративномуРежиму();
	
	ОпределитьВерсиюДрайверов();
	ОпределитьДоступностьКоманд();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзмененАдминистративныйРежим" Тогда
		// АдминистративныйРежим
		НастроитьФормуПоАдминистративномуРежиму();
		НастроитьДоступностьЭлементовПоАдминистративномуРежиму();
		ОпределитьДоступностьКоманд();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииПараметровЭкрана()
	
	// ОриентацияЭкрана
	ПриИзмененииПараметровЭкранаСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	#Если МобильноеПриложениеКлиент Тогда
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	#КонецЕсли
	
	ОбщегоНазначенияКлиент.ПередЗакрытиемФормыНастроек(ЭтотОбъект, Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Готово(Команда)
	
	СохранитьНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьОборудованиеПечати(Команда)
	
	ОчиститьСообщения();
	
	#Если МобильноеПриложениеКлиент Тогда
		
		ПодключаемоеОборудованиеКлиент.ОтключитьОборудование(ОборудованиеПечати);
		
		МенеджерОборудованияКлиент.ВыполнитьНастройкуОборудования(ОборудованиеПечати);
		
	#Иначе
		ТекстОшибки = НСтр("ru = 'Операция доступна только из мобильного приложения'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ТестоваяПечать(Команда)
	
	ОчиститьСообщения();
	
	Отказ = Ложь;
	СохранитьНаКлиенте(Отказ, Ложь);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;

	
	#Если МобильноеПриложениеКлиент Тогда
		
		СтрокиТекста = НСтр("ru = 'Тестовая печать'");
		
		ОчиститьСообщения();
		ВыходныеПараметры = Неопределено;
		ВходныеПараметры = Новый Структура("СтрокиТекста", СтрокиТекста);
		Если Не МенеджерОборудованияКлиент.ВыполнитьПечатьТекста(УникальныйИдентификатор, ОборудованиеПечати, ВходныеПараметры, ВыходныеПараметры) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ВыходныеПараметры.ТекстОшибки);
		КонецЕсли
		
	#Иначе
		ТекстОшибки = НСтр("ru = 'Операция доступна только из мобильного приложения'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
	#КонецЕсли

КонецПроцедуры

&НаКлиенте
Процедура УстановитьДрайверУстройстваПечати(Команда)
	
	ОчиститьСообщения();
	
	#Если МобильноеПриложениеКлиент Тогда
		
		Если НЕ ЗначениеЗаполнено(ДрайверУстройстваПечати) Тогда
			Возврат;
		КонецЕсли;
		
		МенеджерОборудованияКлиент.УстановитьДрайверИзМакета(ДрайверУстройстваПечати);
		ОпределитьВерсиюДрайверов();
		ОпределитьДоступностьКоманд();
		
	#Иначе
		ТекстОшибки = НСтр("ru = 'Операция доступна только из мобильного приложения'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ПараметрыПечати(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ТипОборудования", ТипОборудования);
	ОткрытьФорму("Обработка.НастройкиПриложения.Форма.ПараметрыПечати", ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПараметрыККТ(Команда)
	
	Отказ = Ложь;
	СохранитьНаКлиенте(Отказ, Ложь);
	
	Если НЕ Отказ Тогда
		КассовыеОперацииКлиент.ПоказатьПараметрыККТ(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьСлужебныеОперации(Команда)
	
	КассовыеОперацииКлиент.ПоказатьСлужебныеОперации(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СостояниеККТ(Команда)
	
	Отказ = Ложь;
	СохранитьНаКлиенте(Отказ, Ложь);
	
	Если НЕ Отказ Тогда
		КассовыеОперацииКлиент.ПоказатьСостояниеККТ(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПереключитьАдминистративныйРежим(Команда)
	
	Если НЕ АдминистративныйРежим
		И ОбщегоНазначенияВызовСервера.УстановленПарольАдминистративногоРежима() Тогда
		
		ОбщегоНазначенияКлиент.ОткрытьФормуПереключенияАдминистративногоРежима(ЭтотОбъект);
		
		Возврат;
	КонецЕсли;
	
	АдминистративныйРежим = НЕ АдминистративныйРежим;
	
	ИзменитьАдминистративныйРежим();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементов

&НаКлиенте
Процедура ТипОборудованияПриИзменении(Элемент)
	
	ТипОборудованияПриИзмененииНаСервере();
	
	ОпределитьВерсиюДрайверов();
	
	ОпределитьДоступностьКоманд();
	
КонецПроцедуры

&НаКлиенте
Процедура ДрайверУстройстваПечатиПриИзменении(Элемент)
	
	ДрайверУстройстваПечатиПриИзмененииНаСервере();
	ОпределитьВерсиюДрайверов();
	ОпределитьДоступностьКоманд();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыАдминистративныйРежим

&НаКлиенте
Процедура НастроитьДоступностьЭлементовПоАдминистративномуРежиму()
	
	СписокТолькоПросмотр = "ДрайверУстройстваПечати, ТипОборудования, ЗаводскойНомерККМ";
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементовФормы(ЭтотОбъект, СписокТолькоПросмотр, "ТолькоПросмотр", НЕ АдминистративныйРежим);
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьФормуПоАдминистративномуРежимуКлиент()
	
	// АдминистративныйРежим
	НастроитьДоступностьЭлементовПоАдминистративномуРежиму();
	
	НастроитьФормуПоАдминистративномуРежиму(Истина);
	Оповестить("ИзмененАдминистративныйРежим");
	
КонецПроцедуры

&НаСервере
Процедура НастроитьФормуПоАдминистративномуРежиму(УстановитьРежим = Ложь)
	
	ОбщегоНазначения.НастроитьФормуПоАдминистративномуРежиму(ЭтотОбъект, УстановитьРежим);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьАдминистративныйРежим()
	
	НастроитьОтображениеПереключенияРежима();
	
	ПодключитьОбработчикОжидания("НастроитьФормуПоАдминистративномуРежимуКлиент", 0.2, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьОтображениеПереключенияРежима()
	
	Если АдминистративныйРежим Тогда
		
		Элементы.СтраницыАдминистративныйРежим.ТекущаяСтраница = Элементы.СтраницаРазблокированоПроцесс;
	Иначе
		
		Элементы.СтраницыАдминистративныйРежим.ТекущаяСтраница = Элементы.СтраницаРазблокировать;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция ПроверитьЗаполнениеФормы()
	
	Если ЗначениеЗаполнено(ТипОборудования) И НЕ ЗначениеЗаполнено(ДрайверУстройстваПечати) Тогда
		
		ПомощникUIКлиент.СообщитьПолеНеЗаполнено(ЭтотОбъект, Элементы.ДрайверУстройстваПечати, НСтр("ru = 'Драйвер'"));
		
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

&НаКлиенте
Процедура СохранитьНаКлиенте(Отказ = Ложь, ЗакрытьФорму = Истина) Экспорт
	
	ОчиститьСообщения();
	
	Если НЕ ПроверитьЗаполнениеФормы() Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если Модифицированность Тогда
		СохранитьНаСервере(Отказ);
	КонецЕсли;
	
	Если НЕ Отказ Тогда
		
		Если ОповеститьОбИзмененииЗначенийНастроек Тогда
			Оповестить("ИзмененыЗначенияНастроек");
		КонецЕсли;
		
		Если ЗакрытьФорму Тогда
			Закрыть();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ТипОборудованияПриИзмененииНаСервере()
	
	НастроитьВидимостьУстройстваПечати();
	
	#Если МобильноеПриложениеСервер Тогда
		
	Если ЗначениеЗаполнено(ТипОборудования)
		И ТипОборудования = ПредопределенноеЗначение("Перечисление.ТипыПодключаемогоОборудования.ПринтерЧеков") Тогда
		
		ДрайверУстройстваПечати = ПредопределенноеЗначение("Справочник.ДрайверыОборудования.Драйвер1СПринтерЧеков");
		
	ИначеЕсли ЗначениеЗаполнено(ТипОборудования)
		И ТипОборудования = ПредопределенноеЗначение("Перечисление.ТипыПодключаемогоОборудования.ФискальныйРегистратор") Тогда
		
		ДрайверУстройстваПечати = ПредопределенноеЗначение("Справочник.ДрайверыОборудования.Драйвер1СДрайверFPrint11");
		
	ИначеЕсли ЗначениеЗаполнено(ТипОборудования)
		И ТипОборудования = ПредопределенноеЗначение("Перечисление.ТипыПодключаемогоОборудования.ККТ") Тогда
		
		
		ДрайверУстройстваПечати = ПредопределенноеЗначение("Справочник.ДрайверыОборудования.ДрайверАТОЛККТ54ФЗ10X");
		
	Иначе
		ДрайверУстройстваПечати = ПредопределенноеЗначение("Справочник.ДрайверыОборудования.ПустаяСсылка");
	КонецЕсли;
	
	#Иначе
		
		ДрайверУстройстваПечати = ПредопределенноеЗначение("Справочник.ДрайверыОборудования.ПустаяСсылка");
		
	#КонецЕсли
	
	ДрайверУстройстваПечатиПриИзмененииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНаСервере(Отказ)
	
	ОбщегоНазначения.СохранитьКонстантыФормы(ЭтотОбъект, СписокКонстант(), Отказ);
	
КонецПроцедуры

&НаСервере
Процедура НастроитьФормуПоЗначениямНастроек()
	
	ОбщегоНазначения.УстановитьШрифт(ЭтотОбъект);
	
	ОбщегоНазначения.НастроитьКомандуГотово(ЭтотОбъект);
	
	ОбщегоНазначения.НастроитьКомандуГотово(ЭтотОбъект,
		"ГруппаРазблокировать", "АдминистративныйРежимРазблокировать",, Ложь
	);
	
	ОбщегоНазначения.НастроитьКомандуГотово(ЭтотОбъект,
		"ГруппаРазблокированоПроцесс", "АдминистративныйРежимРазблокированоПроцесс",, Ложь
	);
	
КонецПроцедуры

&НаСервере
Процедура ДрайверУстройстваПечатиПриИзмененииНаСервере()
	
	ПодключаемоеОборудование.ОпределитьПодключаемоеОборудование(ДрайверУстройстваПечати, ОборудованиеПечати);
	
	ОпределитьПараметрыДрайвера();
	
КонецПроцедуры

&НаКлиенте
Процедура ОпределитьВерсиюДрайверов()
	
	ВерсияДрайвераУстройстваПечатиВМакете = "";
	
	ПодключаемоеОборудованиеКлиент.ПолучитьВерсиюДрайвераОборудования(ЭтотОбъект,
		ОборудованиеПечати,
		ВерсияДрайвераУстройстваПечати,
		ВерсияДрайвераУстройстваПечатиВМакете,
		ДрайверУстройстваПечатиУстановлен);
	
	Если НЕ ДрайверУстройстваПечатиУстановлен Тогда
		Элементы.ВерсияДрайвераУстройстваПечати.ЦветТекста = WebЦвета.Кирпичный;
	Иначе
		Элементы.ВерсияДрайвераУстройстваПечати.ЦветТекста = Новый Цвет;
	КонецЕсли;
	
	ЗаголовокКнопки = НСтр("ru = 'Установить драйвер'");
	
	Если ЗначениеЗаполнено(ВерсияДрайвераУстройстваПечатиВМакете) Тогда
		ЗаголовокКнопки = ЗаголовокКнопки + " (" + ВерсияДрайвераУстройстваПечатиВМакете + ")";
	КонецЕсли;
	
	УстановитьЗаголовокКнопкиУстановитьДрайвер(ЗаголовокКнопки);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьЗаголовокКнопкиУстановитьДрайвер(ЗаголовокКнопки)
	
	Элементы.УстановитьДрайверУстройстваПечати.Заголовок = ЗаголовокКнопки;
	
КонецПроцедуры

&НаСервере
Процедура ОпределитьДоступностьКоманд()
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементовФормы(ЭтотОбъект,
		"ПараметрыККТ, СостояниеККТ, ПоказатьСлужебныеОперации",
		"Видимость",
		ТипОборудования = ПредопределенноеЗначение("Перечисление.ТипыПодключаемогоОборудования.ККТ")
	);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементовФормы(ЭтотОбъект,
		"КомандыДрайвера",
		"Видимость",
		ЗначениеЗаполнено(ДрайверУстройстваПечати)
	);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементовФормы(ЭтотОбъект,
		"НастроитьОборудованиеПечати",
		"Доступность",
		АдминистративныйРежим И ЗначениеЗаполнено(ОборудованиеПечати) И ДрайверУстройстваПечатиУстановлен
	);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементовФормы(ЭтотОбъект,
		"УстановитьДрайверУстройстваПечати",
		"Доступность",
		АдминистративныйРежим И ЗначениеЗаполнено(ОборудованиеПечати)
	);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементовФормы(ЭтотОбъект,
		"ТестоваяПечать",
		"Доступность",
		ЗначениеЗаполнено(ОборудованиеПечати) И ДрайверУстройстваПечатиУстановлен
	);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементовФормы(ЭтотОбъект,
		"ПараметрыККТ, СостояниеККТ, ПоказатьСлужебныеОперации",
		"Доступность",
		ЗначениеЗаполнено(ОборудованиеПечати) И ДрайверУстройстваПечатиУстановлен
	);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементовФормы(ЭтотОбъект,
		"УстановитьДрайверУстройстваПечати",
		"Видимость",
		НЕ (ЗначениеЗаполнено(ОборудованиеПечати) И ЭтоДрайверВнешняяКомпонента)
	);
	
КонецПроцедуры

&НаСервере
Процедура НастроитьВидимостьУстройстваПечати()
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементовФормы(ЭтотОбъект, "ГруппаУстройствоПечати", "Видимость", 
		ЗначениеЗаполнено(ТипОборудования));
	
КонецПроцедуры

&НаСервере
Функция СписокКонстант()
	
	Возврат "ОборудованиеПечати, ЗаводскойНомерККМ";
	
КонецФункции

&НаСервере
Процедура ОпределитьПараметрыДрайвера()
	
	Если ЗначениеЗаполнено(ДрайверУстройстваПечати) Тогда
		
		ЭтоДрайверВнешняяКомпонента = НЕ ДрайверУстройстваПечати.ИнтеграционноеПриложение;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОриентацияЭкрана

// ОриентацияЭкрана
&НаСервере
Процедура ПриИзмененииПараметровЭкранаСервер()
	
	ОбщегоНазначения.УстановитьОриентациюЭкрана();
	НастроитьФормуПоОриентацииЭкрана();
	
КонецПроцедуры

&НаСервере
Процедура НастроитьФормуПоОриентацииЭкрана()
	
КонецПроцедуры

#КонецОбласти

