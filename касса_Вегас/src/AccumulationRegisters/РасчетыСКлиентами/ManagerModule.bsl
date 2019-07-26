
#Область ПрограммныйИнтерфейс

Функция ПолучитьДетальныеРасчеты(Заказ) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	РасчетыСКлиентами.Регистратор КАК Документ,
	|	РасчетыСКлиентами.Сумма КАК Сумма,
	|	РасчетыСКлиентами.ПризнакСпособаРасчета КАК ПризнакСпособаРасчета,
	|	РасчетыСКлиентами.ВидДвижения КАК ВидДвижения,
	|	РасчетыСКлиентами.Период КАК Дата,
	|	РасчетыСКлиентами.ТипОплаты
	|ИЗ
	|	РегистрНакопления.РасчетыСКлиентами КАК РасчетыСКлиентами
	|ГДЕ
	|	РасчетыСКлиентами.ЗаказКлиента = &Заказ
	|
	|УПОРЯДОЧИТЬ ПО
	|	РасчетыСКлиентами.Период";
	
	Запрос.УстановитьПараметр("Заказ", Заказ);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат РезультатЗапроса.Выгрузить();
	
КонецФункции

Функция ПолучитьИтогиРасчетов(Заказ) Экспорт
	
	ИтогиРасчетов = Новый Структура;
	
	ИтогиРасчетов.Вставить("ДолгКлиента",  0);
	ИтогиРасчетов.Вставить("СуммаТоваров", 0);
	ИтогиРасчетов.Вставить("СуммаОплаты",  0);
	
	Если НЕ ЗначениеЗаполнено(Заказ) Тогда
		Возврат ИтогиРасчетов;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	РасчетыСКлиентами.Период,
	|	РасчетыСКлиентами.ВидДвижения,
	|	РасчетыСКлиентами.ЗаказКлиента,
	|	РасчетыСКлиентами.Сумма,
	|	РасчетыСКлиентами.ТипОплаты,
	|	РасчетыСКлиентами.ПризнакСпособаРасчета
	|ПОМЕСТИТЬ Расчеты
	|ИЗ
	|	РегистрНакопления.РасчетыСКлиентами КАК РасчетыСКлиентами
	|ГДЕ
	|	РасчетыСКлиентами.ЗаказКлиента = &Заказ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СУММА(ВЫБОР
	|			КОГДА Расчеты.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|				ТОГДА Расчеты.Сумма
	|			ИНАЧЕ -Расчеты.Сумма
	|		КОНЕЦ) КАК СуммаТоваров,
	|	0 КАК СуммаОплаты
	|ПОМЕСТИТЬ СуммыРасчетов
	|ИЗ
	|	Расчеты КАК Расчеты
	|ГДЕ
	|	Расчеты.ТипОплаты = ЗНАЧЕНИЕ(Перечисление.ТипыОплаты.ПустаяСсылка)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	0,
	|	СУММА(ВЫБОР
	|			КОГДА Расчеты.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|				ТОГДА -Расчеты.Сумма
	|			ИНАЧЕ Расчеты.Сумма
	|		КОНЕЦ)
	|ИЗ
	|	Расчеты КАК Расчеты
	|ГДЕ
	|	НЕ Расчеты.ТипОплаты = ЗНАЧЕНИЕ(Перечисление.ТипыОплаты.ПустаяСсылка)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СУММА(СуммыРасчетов.СуммаТоваров) КАК СуммаТоваров,
	|	СУММА(СуммыРасчетов.СуммаОплаты) КАК СуммаОплаты,
	|	СУММА(СуммыРасчетов.СуммаТоваров) - СУММА(СуммыРасчетов.СуммаОплаты) КАК ДолгКлиента
	|ИЗ
	|	СуммыРасчетов КАК СуммыРасчетов";
	
	Запрос.УстановитьПараметр("Заказ", Заказ);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Если Выборка.Следующий() Тогда
		
		ИтогиРасчетов.ДолгКлиента 	= Выборка.ДолгКлиента;
		ИтогиРасчетов.СуммаТоваров 	= Выборка.СуммаТоваров;
		ИтогиРасчетов.СуммаОплаты 	= Выборка.СуммаОплаты;
		
	КонецЕсли;
	
	Возврат ИтогиРасчетов;
	
КонецФункции

#КонецОбласти