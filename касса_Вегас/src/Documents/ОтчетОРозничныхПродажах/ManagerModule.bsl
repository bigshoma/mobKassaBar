
#Область ОбработчикиСобытий

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекстЗаголовка = НСтр("ru = 'Отчет о продажах %ПредставлениеНомера% от %ПредставлениеДата%'");
	
	ТекстЗаголовка = СтрЗаменить(ТекстЗаголовка, "%ПредставлениеНомера%", ОбщегоНазначенияКлиентСервер.ПредставлениеНомера(Данные.Ссылка.Номер));
	ТекстЗаголовка = СтрЗаменить(ТекстЗаголовка, "%ПредставлениеДата%",   Формат(Данные.Ссылка.Дата, "ДФ=dd.MM.yy; ДЛФ=D"));
	
	Представление = ТекстЗаголовка;

КонецПроцедуры

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ОтчетыОПродажахКВыгрузке() Экспорт
	
	МассивДокументов = Новый Массив;
	
	Если ЗначениеНастроекВызовСервераПовтИсп.ЭтоАвтономныйРежим() Тогда
		
		Возврат МассивДокументов;
		
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ОтчетОРозничныхПродажах.Ссылка
	|ИЗ
	|	Документ.ОтчетОРозничныхПродажах КАК ОтчетОРозничныхПродажах
	|ГДЕ
	|	ОтчетОРозничныхПродажах.СтатусОбмена = ЗНАЧЕНИЕ(Перечисление.СтатусыОбмена.ГотовКОбмену)
	|	И ОтчетОРозничныхПродажах.Проведен";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	МассивДокументов = РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Ссылка");
	
	Возврат МассивДокументов;
	
КонецФункции

#КонецОбласти

#КонецЕсли