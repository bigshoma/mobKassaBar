
#Область ПрограммныйИнтерфейс

// Цвет информационных надписей
//
Функция ЦветИнформационнойНадписи() Экспорт
	
	Возврат WebЦвета.СинийСоСтальнымОттенком;
	
КонецФункции

// Цвет итоговых надписей
//
Функция ЦветИтоговойНадписи() Экспорт
	
	Возврат WebЦвета.Черный;
	
КонецФункции

// Цвет ошибок
//
Функция ЦветПоляОшибка() Экспорт
	
	Возврат WebЦвета.Кирпичный;
	
КонецФункции

// Цвет ошибок
//
Функция ЦветПоляУспешно() Экспорт
	
	Возврат WebЦвета.ТемноЗеленый;
	
КонецФункции

// Цвет фона помеченной кнопки
//
Функция ЦветПометкиКнопки() Экспорт
	
	Возврат WebЦвета.СеребристоСерый;
	
КонецФункции

// Цвет предупреждающего поля
//
Функция ЦветПредупреждающегоПоля() Экспорт
	
	Возврат Новый Цвет(225, 117, 21);
	
КонецФункции

Функция ЦветТекстаЗаголовка() Экспорт
	
	Возврат WebЦвета.СветлоГрифельноСерый;
	
КонецФункции

Функция ЦветФонаКнопкиГотово() Экспорт
	
	// Зеленый
	// FF00C853
	// Material A700
	Возврат Новый Цвет(0, 200, 83);
	
КонецФункции

Функция ЦветТекстаКнопкиГотово() Экспорт
	
	Возврат WebЦвета.Белый;
	
КонецФункции

#КонецОбласти
