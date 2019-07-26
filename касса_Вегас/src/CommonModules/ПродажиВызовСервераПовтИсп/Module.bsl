
#Область ПрограммныйИнтерфейс

Функция ПолучитьСмену(ОткрыватьСмену = Истина) Экспорт
	
	КассоваяСмена = Неопределено;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	КассоваяСмена.Ссылка
	|ИЗ
	|	Документ.КассоваяСмена КАК КассоваяСмена
	|ГДЕ
	|	КассоваяСмена.Проведен
	|	И НЕ КассоваяСмена.Закрыта";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Если Выборка.Следующий() Тогда
		
		КассоваяСмена = Выборка.Ссылка;
	Иначе
		Если ОткрыватьСмену Тогда
			
			КассоваяСмена = ПродажиВызовСервера.ОткрытьДокументКассоваяСмена();
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат КассоваяСмена;
	
КонецФункции

Функция ПараметрыЧека() Экспорт
	
	Параметры = Новый Структура;
	
	НаборКонстант = Константы.СоздатьНабор("НаименованиеОрганизации, ИНН, КПП, ИмяКассира, НомерКассы, ТекстШапкиЧека, ТекстПодвалаЧека");
	НаборКонстант.Прочитать();
	
	Параметры.Вставить("ОрганизацияНазвание" , НаборКонстант.НаименованиеОрганизации);
	Параметры.Вставить("ОрганизацияИНН"      , НаборКонстант.ИНН);
	Параметры.Вставить("ОрганизацияКПП"      , НаборКонстант.КПП);
	Параметры.Вставить("Кассир"              , ПродажиВызовСервера.ПолучитьИмяКассира());
	Параметры.Вставить("КассирФИО"           , ПродажиВызовСервера.ПолучитьИмяКассира());
	Параметры.Вставить("КассирИНН"           , ПродажиВызовСервера.ПолучитьИННКассира());
	Параметры.Вставить("НомерКассы"          , НаборКонстант.НомерКассы);
	Параметры.Вставить("ТекстШапки"          , НаборКонстант.ТекстШапкиЧека);
	Параметры.Вставить("ТекстПодвала"        , НаборКонстант.ТекстПодвалаЧека);
	Параметры.Вставить("КассирДолжность"     , ПродажиВызовСервера.ПолучитьДолжностьКассира());
	Параметры.Вставить("АдресМагазина"       , ЗначениеНастроекВызовСервераПовтИсп.АдресМагазина());
	Параметры.Вставить("НаименованиеМагазина", ЗначениеНастроекВызовСервераПовтИсп.НаименованиеМагазина());
	Параметры.Вставить("Электронно"          , Ложь);
	Параметры.Вставить("Отправляет1СSMS"     , ЗначениеНастроекВызовСервераПовтИсп.ОтправкаЭлектронногоЧекаМобильнымУстройством());
	Параметры.Вставить("Отправляет1СEmail"   , ЗначениеНастроекВызовСервераПовтИсп.ОтправкаЭлектронногоЧекаМобильнымУстройством());
	
	Возврат Параметры;
	
КонецФункции

Функция ТипВыемкиПриЗакрытииСмены() Экспорт
	
	ТипВыемки = ЗначениеНастроекПовтИсп.ПолучитьЗначениеКонстанты("ТипВыемки");
	
	Возврат ТипВыемки;
	
КонецФункции

Функция КоличествоВидовОплаты() Экспорт
	
	Если НЕ ЗначениеНастроекПовтИсп.ПолучитьЗначениеКонстанты("ИспользоватьОплатуПлатежнымиКартами") Тогда
		Возврат 0;
	КонецЕсли;
	
	КоличествоВидов = Справочники.ВидыОплаты.КоличествоВидовОплаты();
	
	Возврат КоличествоВидов;
	
КонецФункции

Функция ПолучитьВидОплаты() Экспорт
	
	Если НЕ ЗначениеНастроекПовтИсп.ПолучитьЗначениеКонстанты("ИспользоватьОплатуПлатежнымиКартами") Тогда
		Возврат Справочники.ВидыОплаты.ПустаяСсылка();
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ВидыОплаты.Ссылка
	|ИЗ
	|	Справочник.ВидыОплаты КАК ВидыОплаты
	|ГДЕ
	|	НЕ ВидыОплаты.ПометкаУдаления";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Ссылка;
	Иначе
		Возврат Справочники.ВидыОплаты.ПустаяСсылка();
	КонецЕсли;
	
КонецФункции

#КонецОбласти
