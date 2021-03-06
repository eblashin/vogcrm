
Процедура ЗарегистрироватьСостоянияВоронкиПродажПриОбновлении(Параметры) Экспорт
	
	Параметры.ОбработкаЗавершена = Истина;
	
	//////////////////////////////
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	ВложенныйЗапрос.Интерес КАК Интерес,
	                      |	ВложенныйЗапрос.Ответственный,
	                      |	ВложенныйЗапрос.Офис,
	                      |	ВложенныйЗапрос.Партнер,
	                      |	ВложенныйЗапрос.ПотенциальныйКлиент,
	                      |	ВложенныйЗапрос.Подразделение,
	                      |	ВложенныйЗапрос.ОжидаемаяВыручка,
	                      |	ВложенныйЗапрос.ТипУслуги
	                      |ПОМЕСТИТЬ Интересы
	                      |ИЗ
	                      |	(ВЫБРАТЬ РАЗЛИЧНЫЕ ПЕРВЫЕ 100
	                      |		CRM_Взаимодействие.ДокументОснование КАК Интерес,
	                      |		CRM_Взаимодействие.ДокументОснование.Дата КАК Дата,
	                      |		CRM_Взаимодействие.ДокументОснование.Ответственный КАК Ответственный,
	                      |		CRM_Взаимодействие.ДокументОснование.Офис КАК Офис,
	                      |		CRM_Взаимодействие.ДокументОснование.Партнер КАК Партнер,
	                      |		CRM_Взаимодействие.ДокументОснование.ПотенциальныйКлиент КАК ПотенциальныйКлиент,
	                      |		CRM_Взаимодействие.ДокументОснование.Подразделение КАК Подразделение,
	                      |		CRM_Взаимодействие.ДокументОснование.ОжидаемаяВыручка КАК ОжидаемаяВыручка,
	                      |		CRM_Взаимодействие.ДокументОснование.ТипУслуги КАК ТипУслуги
	                      |	ИЗ
	                      |		Документ.CRM_Взаимодействие КАК CRM_Взаимодействие
	                      |			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.CRM_СостоянияВоронкиПродаж КАК CRM_СостоянияВоронкиПродаж
	                      |			ПО CRM_Взаимодействие.ДокументОснование = CRM_СостоянияВоронкиПродаж.Объект
	                      |	ГДЕ
	                      |		CRM_Взаимодействие.ДокументОснование ССЫЛКА Документ.CRM_Интерес
	                      |		И CRM_Взаимодействие.ДокументОснование <> ЗНАЧЕНИЕ(Документ.CRM_Интерес.ПустаяСсылка)
	                      |		И CRM_СостоянияВоронкиПродаж.Объект ЕСТЬ NULL
	                      |		И НЕ CRM_Взаимодействие.ПометкаУдаления
	                      |	
	                      |	УПОРЯДОЧИТЬ ПО
	                      |		Дата УБЫВ) КАК ВложенныйЗапрос
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	Интересы.Интерес КАК Интерес,
	                      |	Интересы.Ответственный КАК Ответственный,
	                      |	Интересы.Офис КАК Офис,
	                      |	Интересы.Партнер КАК Партнер,
	                      |	Интересы.ПотенциальныйКлиент КАК ПотенциальныйКлиент,
	                      |	Интересы.Подразделение КАК Подразделение,
	                      |	Интересы.ОжидаемаяВыручка КАК ОжидаемаяВыручка,
	                      |	Интересы.ТипУслуги КАК ТипУслуги,
	                      |	CRM_Взаимодействие.СостояниеИнтереса КАК СостояниеИнтереса,
	                      |	CRM_Взаимодействие.Дата КАК Дата,
	                      |	CRM_Взаимодействие.ПлановаяДатаЗавершение КАК ПлановаяДатаЗавершение,
	                      |	CRM_Взаимодействие.ДатаЗавершенияВзаимодействия КАК ДатаЗавершенияВзаимодействияМакс,
	                      |	CRM_Взаимодействие.ДатаЗавершенияВзаимодействия КАК ДатаЗавершенияВзаимодействияМин
	                      |ИЗ
	                      |	Документ.CRM_Взаимодействие КАК CRM_Взаимодействие
	                      |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Интересы КАК Интересы
	                      |		ПО (Интересы.Интерес = CRM_Взаимодействие.ДокументОснование)
	                      |ГДЕ
	                      |	НЕ CRM_Взаимодействие.ПометкаУдаления
	                      |	И CRM_Взаимодействие.СтатусВзаимодействия <> ЗНАЧЕНИЕ(Справочник.CRM_СостоянияСобытий.Отменено)
	                      |
	                      |УПОРЯДОЧИТЬ ПО
	                      |	CRM_Взаимодействие.СостояниеИнтереса.РеквизитДопУпорядочивания,
	                      |	CRM_Взаимодействие.Дата
	                      |ИТОГИ
	                      |	МАКСИМУМ(Ответственный),
	                      |	МАКСИМУМ(Офис),
	                      |	МАКСИМУМ(Партнер),
	                      |	МАКСИМУМ(Подразделение),
	                      |	МАКСИМУМ(ОжидаемаяВыручка),
	                      |	МАКСИМУМ(ТипУслуги),
	                      |	МИНИМУМ(Дата),
	                      |	МАКСИМУМ(ДатаЗавершенияВзаимодействияМакс),
	                      |	МИНИМУМ(ДатаЗавершенияВзаимодействияМин)
	                      |ПО
	                      |	Интерес,
	                      |	СостояниеИнтереса");
	
	ВыборкаИнтерес = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаИнтерес.Следующий() Цикл
		ВыборкаЭтап = ВыборкаИнтерес.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Источник = ВыборкаИнтерес.Интерес;
		НаборЗаписей = РегистрыСведений.CRM_СостоянияВоронкиПродаж.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Объект.Установить(Источник);
		НоваяЗапись = Неопределено;
		ИндексАтивного = Неопределено;
		Пока ВыборкаЭтап.Следующий() Цикл
			ДатаНачала = ВыборкаЭтап.Дата;
			Если НЕ ЗначениеЗаполнено(ДатаНачала) Тогда
				ДатаНачала = Источник.Дата;
			КонецЕсли;
			Если ВыборкаЭтап.СостояниеИнтереса <> Справочники.CRM_СостоянияИнтересов.ПервичныйИнтерес Тогда
				ВыборкаВзаимодействия = ВыборкаЭтап.Выбрать();
				Если НоваяЗапись<>Неопределено Тогда
					Пока ВыборкаВзаимодействия.Следующий() Цикл
						Если ЗначениеЗаполнено(ВыборкаВзаимодействия.ДатаЗавершенияВзаимодействияМин) Тогда
							Если ВыборкаВзаимодействия.СостояниеИнтереса		= Справочники.CRM_СостоянияИнтересов.ИнтересПотерян Тогда
								НоваяЗапись.СостояниеЭтапа = Перечисления.CRM_СостоянияЭтаповВоронки.ЗавершенНеудачно;
								Если ИндексАтивного = НаборЗаписей.Индекс(НоваяЗапись) Тогда
									ИндексАтивного = Неопределено;
								КонецЕсли;
							КонецЕсли;
							НоваяЗапись.ДатаЗавершения = ВыборкаВзаимодействия.ДатаЗавершенияВзаимодействияМин;
							ДатаНачала = ВыборкаВзаимодействия.ДатаЗавершенияВзаимодействияМин;
							Прервать;
						КонецЕсли;
					КонецЦикла;
				КонецЕсли;
			КонецЕсли;
			НоваяЗапись	= НаборЗаписей.Добавить();
			НоваяЗапись.Объект = Источник;
			Если ВыборкаЭтап.СостояниеИнтереса = Справочники.CRM_СостоянияИнтересов.ИнтересПотерян
				ИЛИ ВыборкаЭтап.СостояниеИнтереса = Справочники.CRM_СостоянияИнтересов.ИнтересЗакрыт
				ИЛИ ВыборкаЭтап.ДатаЗавершенияВзаимодействияМин <> Дата(1,1,1) Тогда
				
				НоваяЗапись.ДатаЗавершения	= ВыборкаЭтап.ДатаЗавершенияВзаимодействияМакс;
				Если ВыборкаЭтап.СостояниеИнтереса		= Справочники.CRM_СостоянияИнтересов.ИнтересПотерян Тогда
					НоваяЗапись.СостояниеЭтапа		= Перечисления.CRM_СостоянияЭтаповВоронки.ЗавершенНеудачно;
				Иначе
					НоваяЗапись.СостояниеЭтапа		= Перечисления.CRM_СостоянияЭтаповВоронки.ЗавершенУспешно;
				КонецЕсли;
			Иначе
				НоваяЗапись.СостояниеЭтапа			= Перечисления.CRM_СостоянияЭтаповВоронки.Активный;
				НоваяЗапись.ПлановаяДата			= Источник.ДатаСледующегоДействия;
				ИндексАтивного = НаборЗаписей.Индекс(НоваяЗапись);
			КонецЕсли;
			
			НоваяЗапись.Этап			= ВыборкаЭтап.СостояниеИнтереса;
			Если ЗначениеЗаполнено(ВыборкаЭтап.Партнер) Тогда
				НоваяЗапись.Партнер			= ВыборкаЭтап.Партнер;
			ИначеЕсли ЗначениеЗаполнено(ВыборкаЭтап.ПотенциальныйКлиент) Тогда
				НоваяЗапись.Партнер			= ВыборкаЭтап.ПотенциальныйКлиент;
			КонецЕсли;
			НоваяЗапись.Пользователь	= ВыборкаЭтап.Ответственный;
			НоваяЗапись.Подразделение	= ВыборкаЭтап.Подразделение;
			НоваяЗапись.Офис			= ВыборкаЭтап.Офис;
			НоваяЗапись.ТипУслуги		= ВыборкаЭтап.ТипУслуги;
			НоваяЗапись.Сумма			= ВыборкаЭтап.ОжидаемаяВыручка;
			НоваяЗапись.ДатаНачала		= ДатаНачала;
			НоваяЗапись.Количество = 1;
		КонецЦикла;	
		КоличествоЗаписей = НаборЗаписей.Количество();
		Если ИндексАтивного<>Неопределено Тогда
			Если НаборЗаписей[ИндексАтивного].Этап <> Источник.СостояниеИнтереса Тогда
				НаборЗаписей[ИндексАтивного].Этап = Источник.СостояниеИнтереса;
				Если НаборЗаписей[ИндексАтивного].Этап	= Справочники.CRM_СостоянияИнтересов.ИнтересПотерян Тогда
					НаборЗаписей[ИндексАтивного].СостояниеЭтапа		= Перечисления.CRM_СостоянияЭтаповВоронки.ЗавершенНеудачно;
				КонецЕсли;
			КонецЕсли;
		Иначе
			Если НаборЗаписей[КоличествоЗаписей-1].Этап <> Источник.СостояниеИнтереса Тогда
				НаборЗаписей[КоличествоЗаписей-1].Этап = Источник.СостояниеИнтереса;
				Если НаборЗаписей[КоличествоЗаписей-1].Этап	= Справочники.CRM_СостоянияИнтересов.ИнтересПотерян Тогда
					НаборЗаписей[КоличествоЗаписей-1].СостояниеЭтапа		= Перечисления.CRM_СостоянияЭтаповВоронки.ЗавершенНеудачно;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		Если КоличествоЗаписей = 1 Тогда
			Если НаборЗаписей[0].Этап = Справочники.CRM_СостоянияИнтересов.ИнтересПотерян ИЛИ НаборЗаписей[0].Этап = Справочники.CRM_СостоянияИнтересов.ИнтересЗакрыт Тогда
				НоваяЗапись	= НаборЗаписей.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяЗапись, НаборЗаписей[0]); 
				НоваяЗапись.Этап = Справочники.CRM_СостоянияИнтересов.ПервичныйИнтерес;
				НаборЗаписей[0].ДатаНачала = НаборЗаписей[0].ДатаЗавершения;
			КонецЕсли;
		КонецЕсли;
		Попытка
			НаборЗаписей.Записать();
		Исключение
		КонецПопытки;
	КонецЦикла;

	Параметры.ОбработкаЗавершена = ?(Параметры.ОбработкаЗавершена, ВыборкаИнтерес.Количество()=0, ЛОЖЬ);
	
	//////////////////////////////////////////
	Запрос = Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 500
	                      |	ЗадачаИсполнителя.Ссылка
	                      |ИЗ
	                      |	Задача.ЗадачаИсполнителя КАК ЗадачаИсполнителя
	                      |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.CRM_СостоянияВоронкиПродаж КАК CRM_СостоянияВоронкиПродаж
	                      |		ПО ЗадачаИсполнителя.БизнесПроцесс = CRM_СостоянияВоронкиПродаж.Объект
	                      |			И ЗадачаИсполнителя.CRM_ТочкаМаршрута = CRM_СостоянияВоронкиПродаж.Этап
	                      |ГДЕ
	                      |	ЗадачаИсполнителя.БизнесПроцесс ССЫЛКА БизнесПроцесс.CRM_БизнесПроцесс
	                      |	И НЕ ЗадачаИсполнителя.БизнесПроцесс = ЗНАЧЕНИЕ(БизнесПроцесс.CRM_БизнесПроцесс.ПустаяСсылка)
	                      |	И CRM_СостоянияВоронкиПродаж.Объект ЕСТЬ NULL
	                      |	И НЕ ЗадачаИсполнителя.ПометкаУдаления
	                      |
	                      |УПОРЯДОЧИТЬ ПО
	                      |	ЗадачаИсполнителя.ДатаНачала УБЫВ");
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Источник = Выборка.Ссылка;
		НаборЗаписей = РегистрыСведений.CRM_СостоянияВоронкиПродаж.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Объект.Установить(Источник.БизнесПроцесс);
		НаборЗаписей.Отбор.Этап.Установить(Источник.CRM_ТочкаМаршрута);
		
		НоваяЗапись					= НаборЗаписей.Добавить();
		НоваяЗапись.Объект			= Источник.БизнесПроцесс;
		НоваяЗапись.Этап			= Источник.CRM_ТочкаМаршрута;
		Если Источник.Выполнена Тогда
			НоваяЗапись.СостояниеЭтапа = ?(Источник.CRM_Неудача, Перечисления.CRM_СостоянияЭтаповВоронки.ЗавершенНеудачно, Перечисления.CRM_СостоянияЭтаповВоронки.ЗавершенУспешно);
		Иначе	
			НоваяЗапись.СостояниеЭтапа	= Перечисления.CRM_СостоянияЭтаповВоронки.Активный;
		КонецЕсли;
		НоваяЗапись.Партнер			= Источник.БизнесПроцесс.Партнер;
		НоваяЗапись.КартаМаршрута	= Источник.БизнесПроцесс.КартаМаршрута;
		НоваяЗапись.Пользователь	= Источник.БизнесПроцесс.Ответственный;
		НоваяЗапись.Подразделение	= Источник.БизнесПроцесс.Подразделение;
		Если ЗначениеЗаполнено(НоваяЗапись.Подразделение) Тогда
			НоваяЗапись.Офис			= НоваяЗапись.Подразделение.CRM_Офис;
		КонецЕсли;
		НоваяЗапись.Сумма			= Источник.БизнесПроцесс.Сумма;
		НоваяЗапись.ПлановаяДата	= Источник.СрокИсполнения;
		НоваяЗапись.ДатаНачала		= ?(ЗначениеЗаполнено(Источник.ДатаНачала), Источник.ДатаНачала, Источник.Дата);
		НоваяЗапись.ДатаЗавершения	= Источник.ДатаИсполнения;
		НоваяЗапись.Количество = 1;
		Попытка
			НаборЗаписей.Записать();
		Исключение
		КонецПопытки;
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = ?(Параметры.ОбработкаЗавершена, Выборка.Количество()=0, ЛОЖЬ);
	
	///////////////////////
	Для каждого Тип из Метаданные.ПланыВидовХарактеристик.CRM_ВидыОбъектовБизнесПроцессов.Тип.Типы() Цикл
		Если НЕ Тип = Тип("ДокументСсылка.CRM_Взаимодействие") И CRM_ВоронкиПродажСервер.ЭтоТипОбъектаВоронкиПродаж(Тип) Тогда
			
			МетаданныеТипа = Метаданные.НайтиПоТипу(Тип);
			Если Метаданные.Справочники.Содержит(МетаданныеТипа) Тогда
				Продолжить;
			КонецЕсли;
			ПолноеИмя = МетаданныеТипа.Имя;
			Если Не ЗначениеЗаполнено(ПолноеИмя) Тогда Продолжить; КонецЕсли;
			
			Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 500 Документ.Ссылка КАК Ссылка
			|
			|ИЗ Документ." + ПолноеИмя + " КАК Документ
            |	ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.CRM_СостоянияВоронкиПродаж КАК CRM_СостоянияВоронкиПродаж
            |	ПО Документ.Ссылка = CRM_СостоянияВоронкиПродаж.Объект
            |ГДЕ
            |	CRM_СостоянияВоронкиПродаж.Объект ЕСТЬ NULL
            |		И Документ.СуммаДокумента > 0
            |		И НЕ Документ.ПометкаУдаления
	        |УПОРЯДОЧИТЬ ПО
	        |	Документ.Дата УБЫВ";
			
			Если ПолноеИмя <> "КоммерческоеПредложениеКлиенту" Тогда
				Запрос.Текст = СтрЗаменить(Запрос.Текст, "И Документ.СуммаДокумента > 0", "");
			КонецЕсли;
			Выборка = Запрос.Выполнить().Выбрать();
			Пока Выборка.Следующий() Цикл
				CRM_ВоронкиПродажСервер.ПриЗаписиОбъектаВоронкиПродаж(Выборка.Ссылка, Ложь);
			КонецЦикла;
			
			
			Если Выборка.Количество()<>0 Тогда
				Параметры.ОбработкаЗавершена = ЛОЖЬ;
				Прервать;
			КонецЕсли;
			
			Параметры.ОбработкаЗавершена = ?(Параметры.ОбработкаЗавершена, Выборка.Количество()=0, ЛОЖЬ);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры
