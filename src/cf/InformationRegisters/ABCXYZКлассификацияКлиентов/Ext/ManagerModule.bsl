#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ОчиститьABCКлассификацию() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	НаборЗаписей = РегистрыСведений.ABCXYZКлассификацияКлиентов.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ТипКлассификации.Установить(Перечисления.ТипыКлассификации.ABC);
	НаборЗаписей.Записать();
	
КонецПроцедуры

Процедура ОчиститьXYZКлассификацию() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	НаборЗаписей = РегистрыСведений.ABCXYZКлассификацияКлиентов.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ТипКлассификации.Установить(Перечисления.ТипыКлассификации.XYZ);
	НаборЗаписей.Записать();
	
КонецПроцедуры

#КонецЕсли