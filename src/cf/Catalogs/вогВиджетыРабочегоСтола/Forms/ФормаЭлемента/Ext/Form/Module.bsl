
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СправочникОбъект = РеквизитФормыВЗначение("Объект");
	НастройкиВиджета = СправочникОбъект.НастройкиВиджета.Получить();
	
	Если Не НастройкиВиджета = Неопределено Тогда
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, НастройкиВиджета, "КодЭлемента, КодСтиля, КодФормирования");
		
		АдресКартинки = ПоместитьВоВременноеХранилище(НастройкиВиджета.Изображение, Новый УникальныйИдентификатор); 
		
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	СтруктураНастроек = ТекущийОбъект.НастройкиВиджета.Получить();
	
	Если СтруктураНастроек = Неопределено Тогда
		СтруктураНастроек = Новый Структура("КодЭлемента, КодСтиля, КодФормирования, Изображение", КодЭлемента, КодСтиля, КодФормирования, "");
	Иначе
		ЗаполнитьЗначенияСвойств(СтруктураНастроек, ЭтотОбъект, "КодЭлемента, КодСтиля, КодФормирования");
	КонецЕсли;	
	
	Если ЭтоАдресВременногоХранилища(АдресКартинки) Тогда
		СтруктураНастроек.Изображение = ПолучитьИзВременногоХранилища(АдресКартинки);
	КонецЕсли;	
	
	ТекущийОбъект.НастройкиВиджета = Новый ХранилищеЗначения(СтруктураНастроек, Новый СжатиеДанных(9));
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьКартинку(Команда)
	
	НачатьПомещениеФайла(Новый ОписаниеОповещения("ПослеВыборкаКартинки",   ЭтотОбъект),,,Истина,УникальныйИдентификатор);
	
КонецПроцедуры

 &НаКлиенте
Процедура ПослеВыборкаКартинки(Результат, Адрес, ВыбранноеИмяФайла, ДополнительныеПараметры) Экспорт
	
	Если Не Результат Тогда
		Возврат; 
	КонецЕсли;
	
	АдресКартинки 	= Адрес;
	
КонецПроцедуры
