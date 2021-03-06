
#Область ПрограммныйИнтерфейс

Функция ФорматСуммовыхПолей() Экспорт
	
	ФорматПолей = "ЧЦ=15; ЧДЦ=2; ЧРД=.; ЧН=0.00; ЧГ=0";
	
	Возврат ФорматПолей;
	
КонецФункции

Функция ПолучитьСоздатьЕдиницуИзмерения(Наименование) Экспорт
	
	Если НЕ ЗначениеЗаполнено(Наименование) Тогда
		Наименование ="шт";
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ЕдиницыИзмерения.Ссылка
	|ИЗ
	|	Справочник.ЕдиницыИзмерения КАК ЕдиницыИзмерения
	|ГДЕ
	|	ЕдиницыИзмерения.Наименование ПОДОБНО &Наименование";
	
	Запрос.УстановитьПараметр("Наименование", Наименование);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Если Выборка.Следующий() Тогда
		ЕдиницаИзмерения = Выборка.Ссылка;
	Иначе
		ЕдиницаИзмеренияОбъект = Справочники.ЕдиницыИзмерения.СоздатьЭлемент();
		ЕдиницаИзмеренияОбъект.Наименование = Наименование;
		ЕдиницаИзмеренияОбъект.НаименованиеПолное = Наименование;
		ЕдиницаИзмеренияОбъект.Записать();
		ЕдиницаИзмерения = ЕдиницаИзмеренияОбъект.Ссылка;
	КонецЕсли;
	
	Возврат ЕдиницаИзмерения;
	
КонецФункции

Функция ПолучитьЕдиницуИзмерения(Наименование, ЗначениеПоУмолчанию = Неопределено) Экспорт
	
	Если ЗначениеПоУмолчанию = Неопределено Тогда
		ЕдиницаИзмерения = Справочники.ЕдиницыИзмерения.ПустаяСсылка();
	Иначе
		ЕдиницаИзмерения = ЗначениеПоУмолчанию;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ЕдиницыИзмерения.Ссылка
	|ИЗ
	|	Справочник.ЕдиницыИзмерения КАК ЕдиницыИзмерения
	|ГДЕ
	|	ЕдиницыИзмерения.Наименование ПОДОБНО &Наименование";
	
	Запрос.УстановитьПараметр("Наименование", Наименование);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Если Выборка.Следующий() Тогда
		ЕдиницаИзмерения = Выборка.Ссылка;
	КонецЕсли;
	
	Возврат ЕдиницаИзмерения;
	
КонецФункции

Функция ПолучитьГруппуТоваров(Наименование, ЗначениеПоУмолчанию = Неопределено) Экспорт
	
	Если ЗначениеПоУмолчанию = Неопределено Тогда
		Группа = Справочники.ЕдиницыИзмерения.ПустаяСсылка();
	Иначе
		Группа = ЗначениеПоУмолчанию;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	Номенклатура.Ссылка
	|ИЗ
	|	Справочник.Номенклатура КАК Номенклатура
	|ГДЕ
	|	Номенклатура.Наименование ПОДОБНО &Наименование
	|	И Номенклатура.ЭтоГруппа";
	
	Запрос.УстановитьПараметр("Наименование", Наименование);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Если Выборка.Следующий() Тогда
		Группа = Выборка.Ссылка;
	КонецЕсли;
	
	Возврат Группа;
	
КонецФункции

Функция ПолучитьВидАлкогольнойПродукцииПоКоду(КодАлкогольнойПродукции) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВидыАлкогольнойПродукции.Ссылка КАК ВидыАлкогольнойПродукции
	|ИЗ
	|	Справочник.ВидыАлкогольнойПродукции КАК ВидыАлкогольнойПродукции
	|ГДЕ
	|	ВидыАлкогольнойПродукции.Код = &Код";
	
	Запрос.УстановитьПараметр("Код", КодАлкогольнойПродукции);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка.ВидыАлкогольнойПродукции;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

Функция ПолучитьПризнакПредметаРасчетаПоКоду(КодПризнакаПредметаРасчета) Экспорт
	
	Если КодПризнакаПредметаРасчета = 1 Тогда
		
		ПризнакПредметаРасчета = Перечисления.ПризнакиПредметаРасчета.Товар;
		
	ИначеЕсли КодПризнакаПредметаРасчета = 2 Тогда
		ПризнакПредметаРасчета = Перечисления.ПризнакиПредметаРасчета.ПодакцизныйТовар;
		
	ИначеЕсли КодПризнакаПредметаРасчета = 3 Тогда
		ПризнакПредметаРасчета = Перечисления.ПризнакиПредметаРасчета.Работа;
		
	ИначеЕсли КодПризнакаПредметаРасчета = 4 Тогда
		ПризнакПредметаРасчета = Перечисления.ПризнакиПредметаРасчета.Услуга;
		
	ИначеЕсли КодПризнакаПредметаРасчета = 5 Тогда
		ПризнакПредметаРасчета = Перечисления.ПризнакиПредметаРасчета.СтавкаАзартнойИгры;
		
	ИначеЕсли КодПризнакаПредметаРасчета = 6 Тогда
		ПризнакПредметаРасчета = Перечисления.ПризнакиПредметаРасчета.ВыигрышАзартнойИгры;
		
	ИначеЕсли КодПризнакаПредметаРасчета = 7 Тогда
		ПризнакПредметаРасчета = Перечисления.ПризнакиПредметаРасчета.ЛотерейныйБилет;
		
	ИначеЕсли КодПризнакаПредметаРасчета = 8 Тогда
		ПризнакПредметаРасчета = Перечисления.ПризнакиПредметаРасчета.ВыигрышЛотереи;
		
	ИначеЕсли КодПризнакаПредметаРасчета = 9 Тогда
		ПризнакПредметаРасчета = Перечисления.ПризнакиПредметаРасчета.ПредоставлениеРИД;
		
	ИначеЕсли КодПризнакаПредметаРасчета = 10 Тогда
		ПризнакПредметаРасчета = Перечисления.ПризнакиПредметаРасчета.ПлатежВыплата;
		
	ИначеЕсли КодПризнакаПредметаРасчета = 11 Тогда
		ПризнакПредметаРасчета = Перечисления.ПризнакиПредметаРасчета.АгентскоеВознаграждение;
		
	ИначеЕсли КодПризнакаПредметаРасчета = 12 Тогда
		ПризнакПредметаРасчета = Перечисления.ПризнакиПредметаРасчета.СоставнойПредметРасчета;
		
	ИначеЕсли КодПризнакаПредметаРасчета = 13 Тогда
		ПризнакПредметаРасчета = Перечисления.ПризнакиПредметаРасчета.ИнойПредметРасчета;
		
	ИначеЕсли КодПризнакаПредметаРасчета = 14 Тогда
		ПризнакПредметаРасчета = Перечисления.ПризнакиПредметаРасчета.ИмущественноеПраво;
		
	ИначеЕсли КодПризнакаПредметаРасчета = 15 Тогда
		ПризнакПредметаРасчета = Перечисления.ПризнакиПредметаРасчета.ВнереализационныйДоход;
		
	ИначеЕсли КодПризнакаПредметаРасчета = 16 Тогда
		ПризнакПредметаРасчета = Перечисления.ПризнакиПредметаРасчета.СтраховыеВзносы;
		
	ИначеЕсли КодПризнакаПредметаРасчета = 17 Тогда
		ПризнакПредметаРасчета = Перечисления.ПризнакиПредметаРасчета.ТорговыйСбор;
		
	ИначеЕсли КодПризнакаПредметаРасчета = 18 Тогда
		ПризнакПредметаРасчета = Перечисления.ПризнакиПредметаРасчета.КурортныйСбор;
		
	ИначеЕсли КодПризнакаПредметаРасчета = 19 Тогда
		ПризнакПредметаРасчета = Перечисления.ПризнакиПредметаРасчета.Залог;
		
	Иначе
		
		ПризнакПредметаРасчета = Перечисления.ПризнакиПредметаРасчета.Товар;
		
	КонецЕсли;
	
	Возврат ПризнакПредметаРасчета;
	
КонецФункции

Функция ПолучитьПризнакАгентаПоКоду(КодПризнакаАгента) Экспорт
	
	Если КодПризнакаАгента = 0 Тогда
		
		Возврат Перечисления.ПризнакиАгента.БанковскийПлатежныйАгент;
		
	ИначеЕсли КодПризнакаАгента = 1 Тогда
		
		Возврат Перечисления.ПризнакиАгента.БанковскийПлатежныйСубагент;
		
	ИначеЕсли КодПризнакаАгента = 2 Тогда
		
		Возврат Перечисления.ПризнакиАгента.ПлатежныйАгент;
		
	ИначеЕсли КодПризнакаАгента = 3 Тогда
		
		Возврат Перечисления.ПризнакиАгента.ПлатежныйСубагент;
		
	ИначеЕсли КодПризнакаАгента = 4 Тогда
		
		Возврат Перечисления.ПризнакиАгента.Поверенный;
		
	ИначеЕсли КодПризнакаАгента = 5 Тогда
		
		Возврат Перечисления.ПризнакиАгента.Комиссионер;
		
	ИначеЕсли КодПризнакаАгента = 6 Тогда
		
		Возврат Перечисления.ПризнакиАгента.Агент;
		
	КонецЕсли;
	
КонецФункции

Функция ПолучитьСтатусЗаказаПоНаименованию(НаименованиеСтатуса) Экспорт
	
	Возврат Перечисления.СтатусыЗаказовКлиентов.ПолучитьСтатусЗаказаПоНаименованию(НаименованиеСтатуса);
	
КонецФункции

Функция ПолучитьСистемуНалогообложенияККТ(СистемаНалогообложения) Экспорт
	
	Если СистемаНалогообложения = Перечисления.СистемыНалогообложения.Общая Тогда
		
		Возврат Перечисления.ТипыСистемНалогообложенияККТ.ОСН;
		
	ИначеЕсли СистемаНалогообложения = Перечисления.СистемыНалогообложения.УпрощеннаяДоход Тогда
		
		Возврат Перечисления.ТипыСистемНалогообложенияККТ.УСНДоход;
		
	ИначеЕсли СистемаНалогообложения = Перечисления.СистемыНалогообложения.УпрощеннаяДоходМинусРасход Тогда
		
		Возврат Перечисления.ТипыСистемНалогообложенияККТ.УСНДоходРасход;
		
	ИначеЕсли СистемаНалогообложения = Перечисления.СистемыНалогообложения.ЕдиныйНалогНаВмененныйДоход Тогда
		
		Возврат Перечисления.ТипыСистемНалогообложенияККТ.ЕНВД;
		
	ИначеЕсли СистемаНалогообложения = Перечисления.СистемыНалогообложения.ЕдиныйСельскохозяйственныйНалог Тогда
		
		Возврат Перечисления.ТипыСистемНалогообложенияККТ.ЕСН;
		
	ИначеЕсли СистемаНалогообложения = Перечисления.СистемыНалогообложения.Патентная Тогда
		
		Возврат Перечисления.ТипыСистемНалогообложенияККТ.Патент;
		
	КонецЕсли;
	
КонецФункции

Функция ПолучитьСистемуНалогообложенияПоКоду(КодСистемыНалогообложения) Экспорт
	
	Если КодСистемыНалогообложения = 1 ИЛИ КодСистемыНалогообложения = "1" Тогда
		Возврат Перечисления.СистемыНалогообложения.УпрощеннаяДоход;
		
	ИначеЕсли КодСистемыНалогообложения = 2 ИЛИ КодСистемыНалогообложения = "2" Тогда
		Возврат Перечисления.СистемыНалогообложения.УпрощеннаяДоходМинусРасход;
		
	ИначеЕсли КодСистемыНалогообложения = 3 ИЛИ КодСистемыНалогообложения = "3" Тогда
		Возврат Перечисления.СистемыНалогообложения.ЕдиныйНалогНаВмененныйДоход;
		
	ИначеЕсли КодСистемыНалогообложения = 4 ИЛИ КодСистемыНалогообложения = "4" Тогда
		Возврат Перечисления.СистемыНалогообложения.ЕдиныйСельскохозяйственныйНалог;
		
	ИначеЕсли КодСистемыНалогообложения = 5 ИЛИ КодСистемыНалогообложения = "5" Тогда
		Возврат Перечисления.СистемыНалогообложения.Патентная;
		
	ИначеЕсли КодСистемыНалогообложения = 0 ИЛИ КодСистемыНалогообложения = "0" Тогда
		Возврат Перечисления.СистемыНалогообложения.Общая;
		
	КонецЕсли;
	
КонецФункции

Функция ПолучитьСтавкуНДСККТ(СтавкаНДС) Экспорт
	
	Если СтавкаНДС = Перечисления.СтавкиНДС.БезНДС Тогда
		
		Возврат "none";
		
	ИначеЕсли СтавкаНДС = Перечисления.СтавкиНДС.НДС0 Тогда
		
		Возврат "0";
		
	ИначеЕсли СтавкаНДС = Перечисления.СтавкиНДС.НДС10 Тогда
		
		Возврат "10";
		
	ИначеЕсли СтавкаНДС = Перечисления.СтавкиНДС.НДС18 Тогда
		
		Возврат "18";
		
	ИначеЕсли СтавкаНДС = Перечисления.СтавкиНДС.НДС18_118 Тогда
		
		Возврат "18/118";
		
	ИначеЕсли СтавкаНДС = Перечисления.СтавкиНДС.НДС10_110 Тогда
		
		Возврат "10/110";
		
	ИначеЕсли СтавкаНДС = Перечисления.СтавкиНДС.НДС20 Тогда
		
		Возврат "20";
		
	ИначеЕсли СтавкаНДС = Перечисления.СтавкиНДС.НДС20_120 Тогда
		
		Возврат "20/120";
		
	КонецЕсли;
	
КонецФункции

Функция ПолучитьКодТипаСистемыНалогообложенияККТ(СистемаНалогообложенияККТ) Экспорт
	
	Возврат МенеджерОборудованияКлиентСервер.КодСистемыНалогообложенияККТ(СистемаНалогообложенияККТ);
	
КонецФункции

Функция ЭтоПланшет() Экспорт
	
	ЭтоПланшет = Ложь;
	
	#Если МобильноеПриложениеСервер Тогда 
		Попытка
			
			ИнформацияЭкрана = ПолучитьИнформациюЭкрановКлиента();
			DPI		= ИнформацияЭкрана[0].DPI;
			Высота	= ИнформацияЭкрана[0].Высота;
			Ширина	= ИнформацияЭкрана[0].Ширина;
			ВысотаDP = Окр(160 / DPI * Высота);
			ШиринаDP = Окр(160 / DPI * Ширина);
			Диагональ = Окр(Sqrt((Высота/DPI*Высота/DPI)+(Ширина/DPI*Ширина/DPI)));
			Если Диагональ < 7 Тогда  // http://developer.android.com/intl/ru/design/style/metrics-grids.html
				ЭтоПланшет = Ложь;
			Иначе
				ЭтоПланшет = Истина;
			КонецЕсли;
		
		Исключение
			ЭтоПланшет = Ложь;
		КонецПопытки;
			
	#Иначе
		ЭтоПланшет = Истина;
	#КонецЕсли
	
	Возврат ЭтоПланшет;
	
КонецФункции

#КонецОбласти
