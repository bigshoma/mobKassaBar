
#Область ПрограммныйИнтерфейс

Функция ПередаваемыеДанныеНоменклатуры() Экспорт
	
	ДанныеНоменклатуры = Новый Структура;
	ДанныеНоменклатуры.Вставить("Номенклатура");
	ДанныеНоменклатуры.Вставить("Штрихкод");
	ДанныеНоменклатуры.Вставить("НеобходимостьВводаАкцизнойМарки", Ложь);
	ДанныеНоменклатуры.Вставить("Марки", Новый Массив);
	ДанныеНоменклатуры.Вставить("Цена");
	ДанныеНоменклатуры.Вставить("Количество");
	ДанныеНоменклатуры.Вставить("Сумма");
	ДанныеНоменклатуры.Вставить("ЭтоМаркируемаяПродукция", Ложь);
	ДанныеНоменклатуры.Вставить("ТипМаркировки", ПредопределенноеЗначение("Перечисление.ТипыМаркировкиККТ.ПустаяСсылка"));	
	Возврат ДанныеНоменклатуры;
	
КонецФункции

Функция ПолучитьСтруктуруМарки() Экспорт
	
	СтруктураМарки = Новый Структура;
	
	СтруктураМарки.Вставить("ТипМаркировки",
		ПредопределенноеЗначение("Перечисление.ТипыМаркировкиККТ.ПустаяСсылка"));
	
	СтруктураМарки.Вставить("КодМаркировки", "");
	СтруктураМарки.Вставить("ГлобальныйИдентификаторТорговойЕдиницы", "");
	СтруктураМарки.Вставить("СерийныйНомер","");
	СтруктураМарки.Вставить("КлючСвязи", Неопределено);
	
	Возврат СтруктураМарки;
	
КонецФункции

// Заполняет ключи связи по таблице документа или обработки
Процедура ЗаполнитьКлючиСвязиТЧ(ТабличнаяЧасть, ИмяРеквизитаСвязи) Экспорт
	
	ВремКлючСвязи = 0;
	
	Для Каждого СтрокаТЧ Из ТабличнаяЧасть Цикл
		ВремКлючСвязи = ЗаполнитьКлючСвязи(ТабличнаяЧасть, СтрокаТЧ, ИмяРеквизитаСвязи)
	КонецЦикла;
	
КонецПроцедуры

// Заполняет ключ связи таблиц документа или обработки
//
Функция ЗаполнитьКлючСвязи(ТабличнаяЧасть, СтрокаТабличнойЧасти, ИмяРеквизитаСвязи, ВремКлючСвязи = 0) Экспорт
	
	Если НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти[ИмяРеквизитаСвязи]) Тогда
		Если ВремКлючСвязи = 0 Тогда
			Для Каждого СтрокаТЧ Из ТабличнаяЧасть Цикл
				Если ВремКлючСвязи < СтрокаТЧ[ИмяРеквизитаСвязи] Тогда
					ВремКлючСвязи = СтрокаТЧ[ИмяРеквизитаСвязи];
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		СтрокаТабличнойЧасти[ИмяРеквизитаСвязи] = ВремКлючСвязи + 1;
	КонецЕсли;
	
	Возврат СтрокаТабличнойЧасти[ИмяРеквизитаСвязи];
	
КонецФункции

#КонецОбласти
