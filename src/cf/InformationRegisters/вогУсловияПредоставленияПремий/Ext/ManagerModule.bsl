Процедура СоздатьЗаписиРегистраПоАнкете(Анкета, КоммерческоеСоглашение, СтруктураОтбора, ВТранзакции = Истина) Экспорт
	
	ТаблицаСкидок = ПолучитьТаблицуСкидокИзАнкеты(Анкета,СтруктураОтбора);
	
	Если ВТранзакции тогда
		НачатьТранзакцию();
	КонецЕсли;	
		
	Попытка
		НаборЗаписей = РегистрыСведений.вогУсловияПредоставленияПремий.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.КоммерческоеСоглашение.Установить(КоммерческоеСоглашение);
		НаборЗаписей.Отбор.Анкета.Установить(Анкета);
		
		Для каждого Стр из ТаблицаСкидок цикл
			НоваяЗапись = НаборЗаписей.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяЗапись,Стр);
			НоваяЗапись.КоммерческоеСоглашение = КоммерческоеСоглашение;
			НоваяЗапись.Анкета = Анкета;
			Если СокрЛП(Стр.ВыбранныйПериод) = "" тогда
				НоваяЗапись.ВыбранныйПериод = 0;
			ИначеЕсли Стр.Периодичность = Перечисления.Периодичность.Месяц тогда
				Если Стр.ВыбранныйПериод = "Январь" тогда
					НоваяЗапись.ВыбранныйПериод = 1;
				ИначеЕсли Стр.ВыбранныйПериод = "Февраль" тогда
					НоваяЗапись.ВыбранныйПериод = 2;	
				ИначеЕсли Стр.ВыбранныйПериод = "Март" тогда
					НоваяЗапись.ВыбранныйПериод = 3;
				ИначеЕсли Стр.ВыбранныйПериод = "Апрель" тогда
					НоваяЗапись.ВыбранныйПериод = 4;
				ИначеЕсли Стр.ВыбранныйПериод = "Май" тогда
					НоваяЗапись.ВыбранныйПериод = 5;
				ИначеЕсли Стр.ВыбранныйПериод = "Июнь" тогда
					НоваяЗапись.ВыбранныйПериод = 6;					
				ИначеЕсли Стр.ВыбранныйПериод = "Июль" тогда
					НоваяЗапись.ВыбранныйПериод = 7;
				ИначеЕсли Стр.ВыбранныйПериод = "Август" тогда
					НоваяЗапись.ВыбранныйПериод = 8;
				ИначеЕсли Стр.ВыбранныйПериод = "Сентябрь" тогда
					НоваяЗапись.ВыбранныйПериод = 9;					
				ИначеЕсли Стр.ВыбранныйПериод = "Октябрь" тогда
					НоваяЗапись.ВыбранныйПериод = 10;
				ИначеЕсли Стр.ВыбранныйПериод = "Ноябрь" тогда
					НоваяЗапись.ВыбранныйПериод = 11;
				ИначеЕсли Стр.ВыбранныйПериод = "Декабрь" тогда
					НоваяЗапись.ВыбранныйПериод = 12;
				КонецЕсли;	
			ИначеЕсли Стр.Периодичность = Перечисления.Периодичность.Квартал тогда
				Попытка
					НоваяЗапись.ВыбранныйПериод = Число(Лев(Стр.ВыбранныйПериод,1));
				Исключение
					НоваяЗапись.ВыбранныйПериод = 0;
				КонецПопытки;
			//++ VOG Ульянов И.В. 29.04.2020 CRM-609	
			ИначеЕсли Стр.Периодичность = Перечисления.Периодичность.Полугодие тогда
				Попытка
					НоваяЗапись.ВыбранныйПериод = Число(Лев(Стр.ВыбранныйПериод,1));
				Исключение
					НоваяЗапись.ВыбранныйПериод = 0;
				КонецПопытки;	
			//-- VOG Ульянов И.В. 29.04.2020 CRM-609	
			Иначе
				НоваяЗапись.ВыбранныйПериод = 1;
			КонецЕсли;	
			
			НоваяЗапись.КоличествоЭлементов = СохранитьСписокГруппНоменклатуры(Стр.ИдентификаторНГ, Стр.СписокНГ);
		КонецЦикла;			
		НаборЗаписей.Записать(Истина);
		Если ВТранзакции тогда
			ЗафиксироватьТранзакцию();
		КонецЕсли;	
	Исключение
		Сообщить(ОписаниеОшибки());
		Если ВТранзакции тогда
			ОтменитьТранзакцию();
		КонецЕсли;	
	КонецПопытки;
	
КонецПроцедуры

Функция СохранитьСписокГруппНоменклатуры(ИдентификаторНГ,СписокНГ) Экспорт
	
	МассивЭлементов = СтрРазделить(СписокНГ,"; ");
	КоличествоЭлементов = 0;	
	
	НаборЗаписей = РегистрыСведений.вогСпискиГруппНоменклатуры.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Идентификатор.Установить(ИдентификаторНГ);
	
	Если СписокНГ = "" тогда
		СтрокаНабора = НаборЗаписей.Добавить();
		СтрокаНабора.Идентификатор = ИдентификаторНГ;
		СтрокаНабора.НоменклатурнаяГруппа = Справочники.НоменклатурныеГруппы.ПустаяСсылка();	
	Иначе			
		Для каждого ЭлементМассива ИЗ МассивЭлементов цикл
			Если СокрЛП(ЭлементМассива) <> "" тогда
				СтрокаНабора = НаборЗаписей.Добавить();
				СтрокаНабора.Идентификатор = ИдентификаторНГ;
				СтрокаНабора.НоменклатурнаяГруппа = Справочники.НоменклатурныеГруппы.ПолучитьСсылку(Новый УникальныйИдентификатор(ЭлементМассива));	
				КоличествоЭлементов = КоличествоЭлементов + 1;
			КонецЕсли;	
		КонецЦикла;
	КонецЕсли;	
	
	НаборЗаписей.Записать(Истина);
	
	Возврат КоличествоЭлементов;
	
КонецФункции	

Функция ПолучитьТаблицуСкидокИзАнкеты(Анкета, СтруктураОтбора) Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	МАКСИМУМ(ВЫБОР
		|			КОГДА вогАнкетаСостав.ЭлементарныйВопрос = &ЭлементарныйВопросПериодичность
		|				ТОГДА вогАнкетаСостав.Ответ.СвязанноеЗначение
		|			ИНАЧЕ НЕОПРЕДЕЛЕНО
		|		КОНЕЦ) КАК Периодичность,
		|	МАКСИМУМ(ВЫБОР
		|			КОГДА вогАнкетаСостав.ЭлементарныйВопрос = &ЭлементарныйВопросБазаНачисления
		|				ТОГДА вогАнкетаСостав.Ответ.СвязанноеЗначение
		|			ИНАЧЕ НЕОПРЕДЕЛЕНО
		|		КОНЕЦ) КАК БазаНачисления,
		|	МАКСИМУМ(ВЫБОР
		|			КОГДА вогАнкетаСостав.ЭлементарныйВопрос = &ЭлементарныйВопросБазаНачисленияЕИ
		|				ТОГДА вогАнкетаСостав.Ответ
		|			ИНАЧЕ НЕОПРЕДЕЛЕНО
		|		КОНЕЦ) КАК ЕдиницаИзмеренияБазы,
		|	МАКСИМУМ(ВЫБОР
		|			КОГДА вогАнкетаСостав.ЭлементарныйВопрос = &ЭлементарныйВопросПериодДействияС
		|				ТОГДА вогАнкетаСостав.Ответ
		|			ИНАЧЕ ДАТАВРЕМЯ(1, 1, 1)
		|		КОНЕЦ) КАК ПериодДействияС,
		|	МАКСИМУМ(ВЫБОР
		|			КОГДА вогАнкетаСостав.ЭлементарныйВопрос = &ЭлементарныйВопросПериодДействияПо
		|				ТОГДА вогАнкетаСостав.Ответ
		|			ИНАЧЕ ДАТАВРЕМЯ(1, 1, 1)
		|		КОНЕЦ) КАК ПериодДействияПо,
		|	МАКСИМУМ(ВЫБОР
		|			КОГДА вогАнкетаСостав.ЭлементарныйВопрос = &ЭлементарныйВопросДатаЗаключенияПриложения
		|				ТОГДА вогАнкетаСостав.Ответ
		|			ИНАЧЕ ДАТАВРЕМЯ(1, 1, 1)
		|		КОНЕЦ) КАК ДатаЗаключенияПриложения
		|ПОМЕСТИТЬ РеквизитыШапки
		|ИЗ
		|	Документ.вогАнкета.Состав КАК вогАнкетаСостав
		|ГДЕ
		|	вогАнкетаСостав.Ссылка = &Ссылка
		|	И (вогАнкетаСостав.ЭлементарныйВопрос = &ЭлементарныйВопросПериодичность
		|			ИЛИ вогАнкетаСостав.ЭлементарныйВопрос = &ЭлементарныйВопросБазаНачисления
		|			ИЛИ вогАнкетаСостав.ЭлементарныйВопрос = &ЭлементарныйВопросБазаНачисленияЕИ
		|			ИЛИ вогАнкетаСостав.ЭлементарныйВопрос = &ЭлементарныйВопросПериодДействияС
		|			ИЛИ вогАнкетаСостав.ЭлементарныйВопрос = &ЭлементарныйВопросПериодДействияПо
		|			ИЛИ вогАнкетаСостав.ЭлементарныйВопрос = &ЭлементарныйВопросДатаЗаключенияПриложения)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВЫРАЗИТЬ(вогАнкетаСоставОпроса.ОбъектОпроса КАК СТРОКА(1000)) КАК ОбъектОпроса,
		|	МАКСИМУМ(ВЫБОР
		|			КОГДА вогАнкетаСоставОпроса.ВариантОтвета = &ВариантОтветаЛимитС
		|				ТОГДА ВЫРАЗИТЬ(вогАнкетаСоставОпроса.Ответ КАК ЧИСЛО)
		|			ИНАЧЕ 0
		|		КОНЕЦ) КАК ЛимитС,
		|	МАКСИМУМ(ВЫБОР
		|			КОГДА вогАнкетаСоставОпроса.ВариантОтвета = &ВариантОтветаЛимитПо
		|				ТОГДА ВЫРАЗИТЬ(вогАнкетаСоставОпроса.Ответ КАК ЧИСЛО)
		|			ИНАЧЕ 0
		|		КОНЕЦ) КАК ЛимитПо,
		|	МАКСИМУМ(ВЫБОР
		|			КОГДА вогАнкетаСоставОпроса.ВариантОтвета = &ВариантОтветаПериод
		|				ТОГДА ВЫРАЗИТЬ(вогАнкетаСоставОпроса.Ответ КАК СТРОКА(10))
		|			ИНАЧЕ """"
		|		КОНЕЦ) КАК ВыбранныйПериод,
		|	МАКСИМУМ(ВЫБОР
		|			КОГДА вогАнкетаСоставОпроса.ВариантОтвета = &ВариантОтветаПроцентнаяСтавка
		|				ТОГДА ВЫРАЗИТЬ(вогАнкетаСоставОпроса.Ответ КАК ЧИСЛО)
		|			ИНАЧЕ 0
		|		КОНЕЦ) КАК ПроцентнаяСтавкаПремии,
		|	РеквизитыШапки.Периодичность КАК Периодичность,
		|	РеквизитыШапки.БазаНачисления КАК БазаНачисления,
		|	РеквизитыШапки.ЕдиницаИзмеренияБазы КАК ЕдиницаИзмеренияБазы,
		|	РеквизитыШапки.ПериодДействияС КАК ПериодДействияС,
		|	РеквизитыШапки.ПериодДействияПо КАК ПериодДействияПо,
		|	РеквизитыШапки.ДатаЗаключенияПриложения КАК ДатаЗаключенияПриложения
		|ИЗ
		|	Документ.вогАнкета.СоставОпроса КАК вогАнкетаСоставОпроса,
		|	РеквизитыШапки КАК РеквизитыШапки
		|ГДЕ
		|	вогАнкетаСоставОпроса.Ссылка = &Ссылка
		|	И вогАнкетаСоставОпроса.Вопрос = &ВопросУсловияПредоставленияПремии
		|	И (вогАнкетаСоставОпроса.ВариантОтвета = &ВариантОтветаЛимитС
		|			ИЛИ вогАнкетаСоставОпроса.ВариантОтвета = &ВариантОтветаЛимитПо
		|			ИЛИ вогАнкетаСоставОпроса.ВариантОтвета = &ВариантОтветаПериод
		|			ИЛИ вогАнкетаСоставОпроса.ВариантОтвета = &ВариантОтветаПроцентнаяСтавка)
		|
		|СГРУППИРОВАТЬ ПО
		|	ВЫРАЗИТЬ(вогАнкетаСоставОпроса.ОбъектОпроса КАК СТРОКА(1000)),
		|	РеквизитыШапки.Периодичность,
		|	РеквизитыШапки.БазаНачисления,
		|	РеквизитыШапки.ЕдиницаИзмеренияБазы,
		|	РеквизитыШапки.ПериодДействияС,
		|	РеквизитыШапки.ПериодДействияПо,
		|	РеквизитыШапки.ДатаЗаключенияПриложения";
	
	
	Запрос.УстановитьПараметр("ЭлементарныйВопросПериодичность", СтруктураОтбора.ЭлементарныйВопросПериодичность);
	Запрос.УстановитьПараметр("ЭлементарныйВопросБазаНачисления", СтруктураОтбора.ЭлементарныйВопросБазаНачисления);
	Запрос.УстановитьПараметр("ЭлементарныйВопросБазаНачисленияЕИ", СтруктураОтбора.ЭлементарныйВопросБазаНачисленияЕИ);
	Запрос.УстановитьПараметр("ЭлементарныйВопросПериодДействияС", СтруктураОтбора.ЭлементарныйВопросПериодДействияС);
	Запрос.УстановитьПараметр("ЭлементарныйВопросПериодДействияПо", СтруктураОтбора.ЭлементарныйВопросПериодДействияПо);
	Запрос.УстановитьПараметр("ЭлементарныйВопросДатаЗаключенияПриложения", СтруктураОтбора.ЭлементарныйВопросДатаЗаключенияПриложения);
	
	Запрос.УстановитьПараметр("ВопросУсловияПредоставленияПремии", СтруктураОтбора.ВопросУсловияПредоставленияПремии);
	
	Запрос.УстановитьПараметр("ВариантОтветаЛимитС", СтруктураОтбора.ВариантОтветаЛимитС);
	Запрос.УстановитьПараметр("ВариантОтветаЛимитПо", СтруктураОтбора.ВариантОтветаЛимитПо);
	Запрос.УстановитьПараметр("ВариантОтветаПериод", СтруктураОтбора.ВариантОтветаПериод);
	Запрос.УстановитьПараметр("ВариантОтветаПроцентнаяСтавка", СтруктураОтбора.ВариантОтветаПроцентнаяСтавка);
	
	Запрос.УстановитьПараметр("Ссылка", Анкета);
	
	ТЗ = Запрос.Выполнить().Выгрузить();
	
	ТЗ.Колонки.Добавить("ИдентификаторНГ");
	ТЗ.Колонки.Добавить("СписокНГ");
	
	Для каждого Стр из ТЗ цикл
		СтрокаРазбора = СокрЛП(Стр.ОбъектОпроса);
		Стр.ИдентификаторНГ = Лев(СтрокаРазбора, 36);
		Если СтрДлина(СтрокаРазбора) > 38 тогда
			Стр.СписокНГ = Прав(СтрокаРазбора, СтрДлина(СтрокаРазбора) - 38);		
		Иначе	
			Стр.СписокНГ = "";
		КонецЕсли;	
	КонецЦикла;	
	
	Возврат ТЗ;
	
КонецФункции

Функция ПолучитьПредставлениеСписка(Список, ТипСписка) Экспорт
	
	МассивЭлементов = СтрРазделить(Список,"; ");
	ПредставлениеСписка = "";
	
	Для каждого ЭлементМассива ИЗ МассивЭлементов цикл
		Если СокрЛП(ЭлементМассива) <> "" тогда
			ПредставлениеСписка = ПредставлениеСписка + СокрЛП(Справочники[ТипСписка].ПолучитьСсылку(Новый УникальныйИдентификатор(ЭлементМассива)))+"; ";			
		КонецЕсли;	
	КонецЦикла;	
	
	Возврат ПредставлениеСписка;
	
КонецФункции