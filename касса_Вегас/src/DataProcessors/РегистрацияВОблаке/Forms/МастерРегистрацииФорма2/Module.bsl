
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	НастроитьФормуПоЗначениямНастроек();
	
	ЗаполнитьОписание();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзмененыЗначенияНастроек" Тогда
		
		НастроитьФормуПоЗначениямНастроек();
		ЗаполнитьОписание();
		
	ИначеЕсли ИмяСобытия = "ЗакрытьМастер" Тогда
		
		Закрыть();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииПараметровЭкрана()
	
	// ОриентацияЭкрана
	ПриИзмененииПараметровЭкранаСервер();
	
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

#Область ОбработчикиСобытийЭлементов

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПерейтиКРегистрации(Команда)
	
	ОткрытьФорму("Обработка.РегистрацияВОблаке.Форма.МастерРегистрацииФорма3",,
		ЭтотОбъект,
		УникальныйИдентификатор
	);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьМастер(Команда)
	
	РегистрацияВОблакеКлиент.ЗакрытьМастер();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьОписание()
	
	Содержимое1 = НСтр("ru = 'После регистрации вы сразу получите доступ к сервису 1С:Касса – для начала работы в сервисе перейдите по предоставленной ссылке
	|
	|1С:Касса и ваша 1С:Мобильная касса будут работать в режиме синхронизации
	|Параметры синхронизации будут установлены автоматически
	|
	|Работа в 1С:Кассе ведется в web-браузере'"
	);
	
	Содержимое2 = Новый ФорматированнаяСтрока(НСтр("ru = 'Дальнейшее редактирование прайс-листа будет доступно только через сервис 1С:Касса'"),,
		WebЦвета.Кирпичный
	);
	
	Содержимое3 = НСтр("ru = 'Удачной работы!'");
	
	МассивОписания = Новый Массив;
	МассивОписания.Добавить(Содержимое1);
	
	МассивОписания.Добавить(Символы.ПС);
	МассивОписания.Добавить(Символы.ПС);
	
	МассивОписания.Добавить(Содержимое2);
	
	МассивОписания.Добавить(Символы.ПС);
	МассивОписания.Добавить(Символы.ПС);
	
	МассивОписания.Добавить(Содержимое3);
	
	ОписаниеФорматированнаяСтрока = Новый ФорматированнаяСтрока(МассивОписания, ЗначениеНастроекПовтИсп.ШрифтПриложения());
	
	Элементы.Описание.Заголовок = ОписаниеФорматированнаяСтрока;
	
КонецПроцедуры

&НаСервере
Процедура НастроитьФормуПоЗначениямНастроек()
	
	ОбщегоНазначения.УстановитьШрифт(ЭтотОбъект);
	ОбщегоНазначения.УстановитьЖирныйШрифтПолей(ЭтотОбъект, "ПерейтиКРегистрации");
	
КонецПроцедуры

#КонецОбласти


