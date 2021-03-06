
#Область ПрограммныйИнтерфейс

Функция ПолучитьПолныйАдресПодключения(Вариант, ИмяБД, ПортWS, ЗащищенныйПротокол, АдресСервера = "",
		Октет1 = 0, Октет2 = 0, Октет3 = 0, Октет4 = 0) Экспорт
	
	Шаблон = "%http%://%АдресСервера%/%ИмяБазыДанных%";
	
	АдресСервераСтрокой = АдресСервера;
	
	Если Вариант = "IP" Тогда //0
		
		АдресСервераИнфо = ""
			+ Октет1
			+ "."
			+ Октет2
			+ "."
			+ Октет3
			+ "."
			+ Октет4
			+ ":"
			+ ?(ЗначениеЗаполнено(ПортWS), Формат(ПортWS,"ЧГ=0"), 80);
		
	ИначеЕсли Вариант = "Строка" Тогда //1
		
		АдресСервераИнфо = ?(ЗначениеЗаполнено(АдресСервераСтрокой),
			АдресСервераСтрокой,
			НСтр("ru = '<Адрес сервера>'")
		);
		
	ИначеЕсли Вариант = "СтрокаФреш" Тогда //2
		
		АдресСервераСтрокой = АдресСервераФреш();
		АдресСервераИнфо = АдресСервераСтрокой;
		
		ЗащищенныйПротокол = Истина;
		
	КонецЕсли;
	
	Шаблон = СтрЗаменить(Шаблон, "%http%", ?(ЗащищенныйПротокол, "https", "http"));
	
	ИмяБазыДанныхИнфо = ?(ЗначениеЗаполнено(ИмяБД), ИмяБД, НСтр("ru = '<Имя базы данных>'"));
	
	ПолныйАдресПодключения = СтрЗаменить(Шаблон, "%АдресСервера%", АдресСервераИнфо);
	ПолныйАдресПодключения = СтрЗаменить(ПолныйАдресПодключения, "%ИмяБазыДанных%", ИмяБазыДанныхИнфо);
	
	Возврат ПолныйАдресПодключения;
	
КонецФункции

Функция АдресСервераФреш() Экспорт
	
	Возврат "1cfresh.com";
	
КонецФункции

Функция ПолучитьИмяБазы() Экспорт
	
	Возврат "cb";
	
КонецФункции

#КонецОбласти

