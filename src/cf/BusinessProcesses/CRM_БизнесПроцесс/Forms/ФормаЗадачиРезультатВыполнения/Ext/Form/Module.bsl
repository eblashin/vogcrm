
&НаКлиенте
Процедура КомандаОК(Команда)
	
	Закрыть(Новый Структура("Отказ, РезультатВыполнения, ОтложитьНаДату, ДатаИсполнения",Ложь,РезультатВыполнения, ОтложитьНаДату, ДатаИсполнения));
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("ОтложитьНаДату") Тогда
		ОтложитьНаДату = Параметры.ОтложитьНаДату;
	КонецЕсли;
	Если Параметры.Свойство("Задача") Тогда
		Задача = Параметры.Задача;
		НаборМаршрута = РегистрыСведений.CRM_НастройкиЭтаповБизнесПроцессов.СоздатьНаборЗаписей();
		НаборМаршрута.Отбор.Объект.Установить(Задача.БизнесПроцесс);
		НаборМаршрута.Отбор.ТочкаМаршрута.Установить(Задача.CRM_ТочкаМаршрута);
		НаборМаршрута.Прочитать();
		Если НаборМаршрута.Количество()>0 Тогда
			Элементы.ПеренестиСрок.Видимость = НЕ НаборМаршрута[0].ОтложитьНачалоЭтапаДоступно
		КонецЕсли;
		// Управление видимостью и доступностью поля дата исполнения.
		ДатаИсполнения = CRM_ОбщегоНазначенияСервер.ПолучитьТекущуюДатуСеанса();
		Элементы.ДатаИсполнения.Видимость = Задача.БизнесПроцесс.КартаМаршрута.РедактироватьДатуВыполненияЗадач;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	
	Закрыть(Новый Структура("Отказ, РезультатВыполнения, ОтложитьНаДату, ДатаИсполнения", Истина, РезультатВыполнения, ОтложитьНаДату, ДатаИсполнения));
	
КонецПроцедуры

&НаКлиенте
Процедура ПеренестиСрок(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОтложитьСледующуюЗадачуЗавершение", ЭтотОбъект);
	ОткрытьФорму("БизнесПроцесс.CRM_БизнесПроцесс.Форма.ФормаОтложитьСледующуюЗадачу",,,,,,ОписаниеОповещения,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтложитьСледующуюЗадачуЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если ЗначениеЗаполнено(Результат) Тогда
		ОтложитьНаДату = Результат;
	КонецЕсли;
	
КонецПроцедуры
