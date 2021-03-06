
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	НастроитьФормуПоЗначениямНастроек();
	
	// ОриентацияЭкрана
	НастроитьФормуПоОриентацииЭкрана();
	
	ОбщегоНазначения.ВосстановитьНастройкуПользователя(Перечисления.НастройкиПользователя.ЖурналПродажиАлкогольнойПродукцииПериод, Период);
	ОбщегоНазначения.ВосстановитьНастройкуПользователя(Перечисления.НастройкиПользователя.ЖурналПродажиАлкогольнойПродукцииВыводитьТитульныйЛист, ВыводитьТитульныйЛист);
	
	Если НЕ ЗначениеЗаполнено(Период) Тогда
		Период.Вариант = ВариантСтандартногоПериода.Сегодня;
	КонецЕсли;
	
	СформироватьНаСервере();
	
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
	
	ОбщегоНазначенияВызовСервера.СохранитьНастройкуПользователя("ЖурналПродажиАлкогольнойПродукцииПериод", Период);
	ОбщегоНазначенияВызовСервера.СохранитьНастройкуПользователя("ЖурналПродажиАлкогольнойПродукцииВыводитьТитульныйЛист", ВыводитьТитульныйЛист);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	НастроитьКнопкуТитульныйЛист();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементов

&НаКлиенте
Процедура ПериодНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Оповещение = Новый ОписаниеОповещения("ОповещениеВыборПериода", ЭтотОбъект);
	
	ПараметрыФормы = Новый Структура("Период, СкрытьОтменить", Период, Истина);
	ОткрытьФорму("ОбщаяФорма.НастройкаПериода", ПараметрыФормы,,,,,Оповещение);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОтправитьПоEmail(Команда)
	
	#Если МобильноеПриложениеКлиент Тогда
		
		СтруктураПисьма = ПолучитьСтруктуруПисьма();
		
		РаботаСПочтойКлиент.ОтправитьОтчет(СтруктураПисьма);
		
	#Иначе
		
		ОчиститьСообщения();
		ТекстСообщения = НСтр("ru = 'Операция доступна только из мобильного приложения'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		
	#КонецЕсли

КонецПроцедуры

&НаКлиенте
Процедура Печать(Команда)
	
	Результат.Напечатать(РежимИспользованияДиалогаПечати.Использовать);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция ПолучитьСтруктуруПисьма()
	
	СтруктураПисьма = РаботаСПочтойКлиент.СтруктураПисьмаОтчета();
	
	СтруктураПисьма.ТемаПисьма  = ПолучитьТемуПисьма();
	СтруктураПисьма.ТекстПисьма = ОбщегоНазначенияКлиентСервер.ПолучитьТекстДатаФормированияОтчета(ДатаФормирования);
	
	ЗаписанныйФайл = РаботаСПочтойКлиент.ЗаписатьТабДокВФайлПисьма(Результат, СтруктураПисьма.ТемаПисьма);
	
	РаботаСПочтойКлиент.ДобавитьЗаписанныйФайлВоВложениеПисьма(СтруктураПисьма, ЗаписанныйФайл);
	
	Возврат СтруктураПисьма;
	
КонецФункции

&НаСервере
Функция ПолучитьТемуПисьма()
	
	ШаблонТемыПисьма = НСтр("ru = '1С:Мобильная касса. Журнал продажи алкогольной продукции с %ДатаС% по %ДатаПо%'");
	
	ТемаПисьма = СтрЗаменить(ШаблонТемыПисьма, "%ДатаС%", Формат(Период.ДатаНачала, "ДЛФ=D"));
	ТемаПисьма = СтрЗаменить(ТемаПисьма, "%ДатаПо%", Формат(Период.ДатаОкончания, "ДЛФ=D"));
	
	Возврат ТемаПисьма;
	
КонецФункции

&НаСервере
Процедура СформироватьНаСервере()
	
	Результат.Очистить();
	
	ДанныеОтчета = Продажи.ПолучитьЖурналПродажиАлкогольнойПродукции(Период);
	
	МакетОтчета = Обработки.Отчеты.ПолучитьМакет("ЖурналПродажиАлкогольнойПродукции");
	
#Область ТитульныйЛист
	
	Если ВыводитьТитульныйЛист Тогда
		
		ОбластьМакета = МакетОтчета.ПолучитьОбласть("ТитульныйЛист");
		
		ОбластьМакета.Параметры.Заполнить(ДанныеОтчета);
		ОбластьМакета.Параметры.Период = "" + Формат(Период.ДатаНачала, "ДЛФ=D") + " - " + Формат(Период.ДатаОкончания, "ДЛФ=D");
		
		Результат.Вывести(ОбластьМакета);
		Результат.ВывестиГоризонтальныйРазделительСтраниц();
		
	КонецЕсли;
	
#КонецОбласти //ТитульныйЛист

#Область Шапка
	
	ОбластьМакета = МакетОтчета.ПолучитьОбласть("Шапка");
	Результат.Вывести(ОбластьМакета);
	
#КонецОбласти //Шапка

#Область СтрокиТаблицы
	
	НомерСтроки = 0;
	
	ТаблицаТоваров = ДанныеОтчета.Товары;
	
	ТаблицаПериодов = ТаблицаТоваров.Скопировать(,"ДатаПродажи");
	ТаблицаПериодов.Свернуть("ДатаПродажи");
	ТаблицаПериодов.Сортировать("ДатаПродажи Возр");
	
	Для Каждого День Из ТаблицаПериодов Цикл
		
		СтрокиДня = ТаблицаТоваров.Скопировать(Новый Структура("ДатаПродажи", День.ДатаПродажи));
		
		Для Каждого СтрокаОтчета Из СтрокиДня Цикл
			
			ОбластьСтрока = МакетОтчета.ПолучитьОбласть("Строка");
			
			НомерСтроки = НомерСтроки + 1;
			
			ЗаполнитьЗначенияСвойств(ОбластьСтрока.Параметры, СтрокаОтчета);
			ОбластьСтрока.Параметры.НомерСтроки = НомерСтроки;
			
			Результат.Вывести(ОбластьСтрока);
			
		КонецЦикла;
		
		// Итоги по коду
		ИтогиПоКоду = СтрокиДня.Скопировать();
		ИтогиПоКоду.Свернуть("КодВидаПродукции", "Количество");
		ИтогиПоКоду.Сортировать("КодВидаПродукции Возр");
		
		Для Каждого ТекСтрока Из ИтогиПоКоду Цикл
			ОбластьМакета = МакетОтчета.ПолучитьОбласть("ИтогиПоКоду");
			ЗаполнитьЗначенияСвойств(ОбластьМакета.Параметры, ТекСтрока);
			Результат.Вывести(ОбластьМакета);
		КонецЦикла;
		
		// Итоги по наименованию
		ИтогиПоНаименованию = СтрокиДня.Скопировать();
		ИтогиПоНаименованию.Свернуть("НаименованиеПродукции", "Количество");
		
		Для Каждого ТекСтрока Из ИтогиПоНаименованию Цикл
			ОбластьМакета = МакетОтчета.ПолучитьОбласть("ИтогиПоНаименованию");
			ЗаполнитьЗначенияСвойств(ОбластьМакета.Параметры, ТекСтрока);
			Результат.Вывести(ОбластьМакета);
		КонецЦикла;
		
		// Итоги по количеству
		ОбластьМакета = МакетОтчета.ПолучитьОбласть("ИтогиПоКоличеству");
		ОбластьМакета.Параметры.Количество = СтрокиДня.Итог("Количество");
		Результат.Вывести(ОбластьМакета);
		
	КонецЦикла;
	
#КонецОбласти //СтрокиТаблицы
	
	Результат.РазмерСтраницы = "A4";
	Результат.АвтоМасштаб = Истина;
	Результат.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
	
	ВыводитьГоризонтальныйРазделительСтраниц = Истина;
	
	ДатаФормирования = ОбщегоНазначенияКлиентСервер.ПолучитьТекущуюДату();

КонецПроцедуры

&НаСервере
Процедура НастроитьФормуПоЗначениямНастроек()
	
	ОбщегоНазначения.УстановитьШрифт(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОповещениеВыборПериода(Результат, ДополнительныеПараметры) Экспорт
	
	Если НЕ ТипЗнч(Результат) = Тип("СтандартныйПериод") Тогда
		Возврат;
	КонецЕсли;
	
	Период = Результат;
	СформироватьНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ТитульныйЛист(Команда)
	
	ВыводитьТитульныйЛист = НЕ ВыводитьТитульныйЛист;
	
	НастроитьКнопкуТитульныйЛист();
	
	СформироватьНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьКнопкуТитульныйЛист()
	
	Если ВыводитьТитульныйЛист Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьПометкуКнопки(Элементы.ТитульныйЛист);
	Иначе
		
		ОбщегоНазначенияКлиентСервер.СнятьПометкуКнопки(Элементы.ТитульныйЛист);
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





