
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ОбщегоНазначения.УстановитьЦветИнформационныхНадписей(ЭтаФорма,
		"КаталогДокументовПоУмолчанию,
		|МаскаПрайсЛистаПоУмолчанию,
		|ИмяФайлаОтчетаОПродажахПоУмолчанию,
		|ИДПоУмолчанию,
		|ПолныйАдресПодключения");
	
	НастроитьФормуПоЗначениямНастроек();
	
	НаборКонстант = Константы.СоздатьНабор(СписокКонстант());
	НаборКонстант.Прочитать();
	
	ЗаполнитьЗначенияСвойств(ЭтаФорма, НаборКонстант, СписокКонстант());
	
	// АдминистративныйРежим
	ОбщегоНазначения.НастроитьФормуПоАдминистративномуРежиму(ЭтаФорма);
	ОбщегоНазначения.ВосстановитьНастройкуПользователя(Перечисления.НастройкиПользователя.ВидАдресаПодключенияWS, IPИлиСтрока);
	
	РазобратьАдресWS();
	
	// ОриентацияЭкрана
	ПриИзмененииПараметровЭкранаСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// АдминистративныйРежим
	НастроитьДоступностьЭлементовПоАдминистративномуРежиму();
	
	КаталогДокументовПоУмолчанию = КаталогДокументов();
	МаскаПрайсЛистаПоУмолчанию   = "ExportData";
	ИмяФайлаОтчетаОПродажахПоУмолчанию = "ImportData";
	ИмяФайлаНастроекПоУмолчанию = "Settings";
	ИДПоУмолчанию = "MobKas01";
	
	УстановитьТекущуюСтраницу();
	
	ОбновитьПолныйАдресПодключения();
	НастроитьОтображениеАдресаСервера();
	
	Если ЗначениеЗаполнено(ПарольWS) Тогда
		Элементы.СтраницыWsПароль.ТекущаяСтраница = Элементы.СтраницаWsПарольБезГлаза;
	Иначе
		НастроитьОтображениеПароля();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	Если ОповеститьОбИзмененииЗначенийНастроек Тогда
		ОбщегоНазначенияВызовСервера.СохранитьНастройкуПользователя("ВидАдресаПодключенияWS", IPИлиСтрока);
	КонецЕсли;
	
	ОбщегоНазначенияКлиент.ПередЗакрытиемФормыНастроек(ЭтаФорма, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииПараметровЭкрана()
	
	// ОриентацияЭкрана
	ПриИзмененииПараметровЭкранаСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзмененАдминистративныйРежим" Тогда
		// АдминистративныйРежим
		НастроитьФормуПоАдминистративномуРежиму();
		НастроитьДоступностьЭлементовПоАдминистративномуРежиму();
		
		НастроитьОтображениеАдресаСервера();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементов

&НаКлиенте
Функция ПроверитьЗаполнениеФормы()
	
	Если НЕ ЗначениеЗаполнено(ВидТранспортаСообщенийОбмена) Тогда
		
		ПомощникUIКлиент.СообщитьПолеНеЗаполнено(ЭтотОбъект,
			Элементы.ВидТранспортаСообщенийОбмена,
			НСтр("ru = 'Тип синхронизации'")
		);
		
		Возврат Ложь;
	КонецЕсли;
	
	Если ВидТранспортаСообщенийОбмена = ПредопределенноеЗначение("Перечисление.ВидыТранспортаСообщенийОбмена.WS") Тогда
		
		Если НЕ ЗначениеЗаполнено(ИдентификаторУстройства) Тогда
		
			ПомощникUIКлиент.СообщитьПолеНеЗаполнено(ЭтотОбъект,
				Элементы.ИдентификаторУстройства,
				НСтр("ru = 'Идентификатор информационной базы'")
			);
			
			Возврат Ложь;
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(АдресСервераСтрокой) И НЕ IPИлиСтрока = 0 Тогда
		
			ПомощникUIКлиент.СообщитьПолеНеЗаполнено(ЭтотОбъект,
				Элементы.АдресСервераСтрокой,
				НСтр("ru = 'Адрес сервера'")
			);
			
			Возврат Ложь;
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(ИмяБД) Тогда
		
			ПомощникUIКлиент.СообщитьПолеНеЗаполнено(ЭтотОбъект,
				Элементы.ИмяБД,
				НСтр("ru = 'Имя базы данных'")
			);
			
			Возврат Ложь;
		КонецЕсли;
		
	Иначе
		
		Если НЕ ЗначениеЗаполнено(КаталогФайловогоОбмена) Тогда
		
			ПомощникUIКлиент.СообщитьПолеНеЗаполнено(ЭтотОбъект,
				Элементы.КаталогФайловогоОбмена,
				НСтр("ru = 'Каталог обмена'")
			);
			
			Возврат Ложь;
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(МаскаФайловПрайсЛиста) Тогда
		
			ПомощникUIКлиент.СообщитьПолеНеЗаполнено(ЭтотОбъект,
				Элементы.МаскаФайловПрайсЛиста,
				НСтр("ru = 'Имя файла загрузки'")
			);
			
			Возврат Ложь;
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(ИмяФайлаОтчетаОПродажах) Тогда
		
			ПомощникUIКлиент.СообщитьПолеНеЗаполнено(ЭтотОбъект,
				Элементы.ИмяФайлаОтчетаОПродажах,
				НСтр("ru = 'Имя файла выгрузки'")
			);
			
			Возврат Ложь;
		КонецЕсли;
		
	КонецЕсли;
		
	Возврат Истина;
	
КонецФункции

&НаКлиенте
Процедура ВидТранспортаСообщенийОбменаПриИзменении(Элемент)
	
	УстановитьТекущуюСтраницу();
	
КонецПроцедуры

&НаКлиенте
Процедура ИмяБДПриИзменении(Элемент)
	
	ОбновитьПолныйАдресПодключения();
	
КонецПроцедуры

&НаКлиенте
Процедура IPИлиСтрокаПриИзменении(Элемент)
	
	Если IPИлиСтрока = 2 Тогда
		
		АдресСервераСтрокой = СинхронизацияКлиентСервер.АдресСервераФреш();
		
	КонецЕсли;
	
	ОбновитьПолныйАдресПодключения();
	НастроитьОтображениеАдресаСервера();
	
КонецПроцедуры

&НаКлиенте
Процедура АдресСервераСтрокойПриИзменении(Элемент)
	ОбновитьПолныйАдресПодключения();
КонецПроцедуры

&НаКлиенте
Процедура Октет1ПриИзменении(Элемент)
	ОбновитьПолныйАдресПодключения();
	
	ТекущийЭлемент = Элементы.Октет2;
	
	#Если МобильноеПриложениеКлиент Тогда
	НачатьРедактированиеЭлемента();
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура Октет2ПриИзменении(Элемент)
	ОбновитьПолныйАдресПодключения();
	
	
	ТекущийЭлемент = Элементы.Октет3;
	
	#Если МобильноеПриложениеКлиент Тогда
	НачатьРедактированиеЭлемента();
	#КонецЕсли

КонецПроцедуры

&НаКлиенте
Процедура Октет3ПриИзменении(Элемент)
	ОбновитьПолныйАдресПодключения();
	
	ТекущийЭлемент = Элементы.Октет4;
	
	#Если МобильноеПриложениеКлиент Тогда
	НачатьРедактированиеЭлемента();
	#КонецЕсли

КонецПроцедуры

&НаКлиенте
Процедура Октет4ПриИзменении(Элемент)
	
	ОбновитьПолныйАдресПодключения();
	
	Если НЕ ЗначениеЗаполнено(ИмяБД) Тогда
		ТекущийЭлемент = Элементы.ИмяБД;
		
		#Если МобильноеПриложениеКлиент Тогда
		НачатьРедактированиеЭлемента();
		#КонецЕсли
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПортWSПриИзменении(Элемент)
	
	ОбновитьПолныйАдресПодключения();
	
	Если НЕ ЗначениеЗаполнено(ИмяБД) Тогда
		ТекущийЭлемент = Элементы.ИмяБД;
		
		#Если МобильноеПриложениеКлиент Тогда
		НачатьРедактированиеЭлемента();
		#КонецЕсли
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ЗащищенныйПротоколПриИзменении(Элемент)
	
	ОбновитьПолныйАдресПодключения();
	
КонецПроцедуры

&НаКлиенте
Процедура ПарольWSПриИзменении(Элемент)
	
	Если НЕ ЗначениеЗаполнено(ПарольWS) Тогда
		
		НастроитьОтображениеПароля();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Готово(Команда)
	
	СохранитьНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьКаталогФайловогоОбмена(Команда)
	
	КаталогФайловогоОбмена = КаталогДокументовПоУмолчанию;
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьМаскуПрайсЛиста(Команда)
	
	МаскаФайловПрайсЛиста = МаскаПрайсЛистаПоУмолчанию;
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьИмяФайлаОтчета(Команда)
	
	ИмяФайлаОтчетаОПродажах = ИмяФайлаОтчетаОПродажахПоУмолчанию; 
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьИмяФайлаНастроек(Команда)
	
	ИмяФайлаНастроек = ИмяФайлаНастроекПоУмолчанию;
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьИдентификаторПоУмолчанию(Команда)
	
	ИдентификаторУстройства = ИДПоУмолчанию;
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьПодключение(Команда)
	
	ОчиститьСообщения();
	
	Отказ = Ложь;
	
	Если НЕ ПроверитьЗаполнениеФормы() Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ПроверитьПодключениеНаСервере(Отказ);
	
	Если НЕ Отказ Тогда
		
		Если ОповеститьОбИзмененииЗначенийНастроек Тогда
			Оповестить("ИзмененыЗначенияНастроек");
		КонецЕсли;
		
		ТекстСообщения = НСтр("ru = 'Подключение успешно установлено'");
		ПоказатьПредупреждение(, ТекстСообщения,," ");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьСкрытьПароль(Команда)
	
	ПарольОтображается = НЕ ПарольОтображается;
	НастроитьОтображениеПароля();
	
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

#Область СлужебныеПроцедурыАдминистративныйРежим

&НаКлиенте
Процедура НастроитьДоступностьЭлементовПоАдминистративномуРежиму()
	
	СписокТолькоПросмотр = 
		"ВидТранспортаСообщенийОбмена,
		|КаталогФайловогоОбмена,
		|МаскаФайловПрайсЛиста,
		|ИмяФайлаОтчетаОПродажах,
		|ИдентификаторУстройства,
		|АдресСервераСтрокой,
		|Октет1,
		|Октет2,
		|Октет3,
		|Октет4,
		|ПортWS,
		|ИмяБД,
		|ПользовательWS,
		|ПарольWS,
		|ПарольWsБезГлаза,
		|ПарольWsГлазПеречеркнутый,
		|ЗагружатьНастройки,
		|ЗащищенныйПротокол";
		
	СписокДоступность = "
		|ЗаполнитьКаталогФайловогоОбмена,
		|ЗаполнитьМаскуПрайсЛиста,
		|ЗаполнитьИмяФайлаОтчета,
		|ЗаполнитьИдентификаторПоУмолчанию,
		|ПоказатьСкрытьПароль,
		|IPИлиСтрока";
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементовФормы(
		ЭтаФорма,
		СписокТолькоПросмотр,
		"ТолькоПросмотр",
		НЕ АдминистративныйРежим
	);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементовФормы(
		ЭтаФорма,
		СписокДоступность,
		"Доступность",
		АдминистративныйРежим
	);
	
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
	
	ОбщегоНазначения.НастроитьФормуПоАдминистративномуРежиму(ЭтаФорма, УстановитьРежим);
	
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

&НаСервере
Функция СписокКонстант()
	
	Возврат "ВидТранспортаСообщенийОбмена,
	|КаталогФайловогоОбмена,
	|МаскаФайловПрайсЛиста,
	|ИмяФайлаОтчетаОПродажах,
	|ИмяФайлаНастроек,
	|ИдентификаторУстройства,
	|АдресWS,
	|ПользовательWS,
	|ПарольWS,
	|ЗагружатьНастройки";
	
КонецФункции

&НаСервере
Процедура РазобратьАдресWS()
	
	СтрокаНаЗабор = АдресWS;
	
	Если НЕ СтрНайти(АдресWS, СинхронизацияКлиентСервер.АдресСервераФреш()) = 0 Тогда
		
		IPИлиСтрока = 2;
	КонецЕсли;
	
	Если Лев(АдресWS, 5) = "https" Тогда
		ЗащищенныйПротокол = Истина;
	КонецЕсли;
	
	Если ЗащищенныйПротокол Тогда
		КоличествоСимволовПодHTTP = 9; // "https://"
	Иначе
		КоличествоСимволовПодHTTP = 8; // "http://"
	КонецЕсли;
	
	СтрокаНаЗабор = Сред(СтрокаНаЗабор, КоличествоСимволовПодHTTP);
	ПозицияСлеша = Найти(СтрокаНаЗабор, "/");
	ИмяБД = Сред(СтрокаНаЗабор,ПозицияСлеша + 1);
	
	
	Если IPИлиСтрока = 0 Тогда
		
		IP = Лев(СтрокаНаЗабор, ПозицияСлеша - 1);
		
		ПозицияДвоеточия = Найти(IP, ":");
		ПортWS = Сред(IP,ПозицияДвоеточия + 1);
		
		IPБезПорта = Лев(IP, ПозицияДвоеточия - 1);
		
		IPМассив = ОбщегоНазначенияКлиентСервер.РазложитьСтрокуВМассивПодстрок(IPБезПорта, ".",, Истина);
		
		СчетчикОктетов = 1;
		Для Каждого Октет Из IPМассив Цикл
			ЭтаФорма["Октет" + СчетчикОктетов] = Октет;
			СчетчикОктетов = СчетчикОктетов + 1;
		КонецЦикла;
		
		ИмяБД = Сред(СтрокаНаЗабор,ПозицияСлеша + 1);
		
	ИначеЕсли IPИлиСтрока = 1 ИЛИ IPИлиСтрока = 2 Тогда
		
		АдресСервераСтрокой = Лев(СтрокаНаЗабор, ПозицияСлеша - 1);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьНаКлиенте() Экспорт
	
	ОчиститьСообщения();
	Отказ = Ложь;
	
	АдресWS = ПолныйАдресПодключения;
	
	Если НЕ ПроверитьЗаполнениеФормы() Тогда
		Возврат;
	КонецЕсли;
	
	Если Модифицированность Тогда
		СохранитьНаСервере(Отказ);
	КонецЕсли;
	
	Если НЕ Отказ Тогда
		
		Если ОповеститьОбИзмененииЗначенийНастроек Тогда
			Оповестить("ИзмененыЗначенияНастроек");
		КонецЕсли;
		
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНаСервере(Отказ)
	
	ОбщегоНазначения.СохранитьКонстантыФормы(ЭтаФорма, СписокКонстант(), Отказ);
	
	Если НЕ Отказ Тогда
		Модифицированность = Ложь;
	КонецЕсли;
	
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

&НаКлиенте
Процедура УстановитьТекущуюСтраницу()
	
	Если ВидТранспортаСообщенийОбмена = ПредопределенноеЗначение("Перечисление.ВидыТранспортаСообщенийОбмена.FILE") Тогда
		
		Элементы.Страницы.ТекущаяСтраница = Элементы.ФайловыйОбмен;
		
	ИначеЕсли ВидТранспортаСообщенийОбмена = ПредопределенноеЗначение("Перечисление.ВидыТранспортаСообщенийОбмена.WS") Тогда
		
		Элементы.Страницы.ТекущаяСтраница = Элементы.WebСервис;
		
	Иначе
		
		Элементы.Страницы.ТекущаяСтраница = Элементы.Пустая;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьПолныйАдресПодключения()
	
	Если IPИлиСтрока = 0 Тогда
		
		Вариант = "IP";
		
	ИначеЕсли IPИлиСтрока = 1 Тогда
		
		Вариант = "Строка";
		
	ИначеЕсли IPИлиСтрока = 2 Тогда
		
		Вариант = "СтрокаФреш"
		
	КонецЕсли;
	
	
	ПолныйАдресПодключения = СинхронизацияКлиентСервер.ПолучитьПолныйАдресПодключения(
		Вариант, ИмяБД, ПортWS, ЗащищенныйПротокол, АдресСервераСтрокой, Октет1, Октет2, Октет3, Октет4
	);
	
КонецПроцедуры

&НаСервере
Процедура НастроитьОтображениеАдресаСервера()
	
	Если IPИлиСтрока = 0 Тогда
		
		Элементы.АдресСтрокой.Видимость = Ложь;
		Элементы.АдресIP.Видимость = Истина;
		
		Если АдминистративныйРежим Тогда
			Элементы.ЗащищенныйПротокол.ТолькоПросмотр = Ложь;
		КонецЕсли;
		
	ИначеЕсли IPИлиСтрока = 1 Тогда
		
		Элементы.АдресСтрокой.Видимость = Истина;
		
		Элементы.АдресIP.Видимость = Ложь;
		
		Если АдминистративныйРежим Тогда
			Элементы.АдресСтрокой.ТолькоПросмотр = Ложь;
			Элементы.ЗащищенныйПротокол.ТолькоПросмотр = Ложь;
		КонецЕсли;
		
	ИначеЕсли IPИлиСтрока = 2 Тогда
		
		Элементы.АдресСтрокой.Видимость = Истина;
		
		Элементы.АдресIP.Видимость = Ложь;
		
		Если АдминистративныйРежим Тогда
			Элементы.АдресСтрокой.ТолькоПросмотр = Истина;
			Элементы.ЗащищенныйПротокол.ТолькоПросмотр = Истина;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьПодключениеНаСервере(Отказ)
	
	АдресWS = ПолныйАдресПодключения;
	
	СохранитьНаСервере(Отказ);
	
	СообщениеОбОшибке = "";
	Синхронизация.ПроверитьУстановитьПодключение(Отказ, СообщениеОбОшибке);
	
	Если Отказ Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеОбОшибке);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьОтображениеПароля()
	
	Если ПарольОтображается Тогда
		
		Элементы.СтраницыWsПароль.ТекущаяСтраница = Элементы.СтраницаWsПарольГлазПеречеркнутый;
		
	Иначе
		
		Элементы.СтраницыWsПароль.ТекущаяСтраница = Элементы.СтраницаWsПарольГлаз;
		
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
