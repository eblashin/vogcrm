&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Задача") И ЗначениеЗаполнено(Параметры.Задача) Тогда
		Задача						= Параметры.Задача;
	КонецЕсли;
	
	Интерес = Параметры.Интерес;
	ОжидаемаяВыручкаУстановить = Интерес.ОжидаемаяВыручка;
	ТекущийПользователь = Пользователи.АвторизованныйПользователь();
КонецПроцедуры

&НаСервере
Функция ОбработатьИнтересНаСервере()
	
	Результат = Новый Структура("Успех, Сообщение, Взаимодействие");
	// обработка интереса
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	CRM_Взаимодействие.Ссылка
	|ИЗ
	|	Документ.CRM_Взаимодействие КАК CRM_Взаимодействие
	|ГДЕ
	|	CRM_Взаимодействие.ДокументОснование = &Интерес
	|	И CRM_Взаимодействие.СтатусВзаимодействия <> ЗНАЧЕНИЕ(Справочник.CRM_СостоянияСобытий.Отменено)
	|	И CRM_Взаимодействие.СтатусВзаимодействия <> ЗНАЧЕНИЕ(Справочник.CRM_СостоянияСобытий.Завершено)
	|
	|УПОРЯДОЧИТЬ ПО
	|	CRM_Взаимодействие.ПлановаяДата УБЫВ";
	Запрос.УстановитьПараметр("Интерес", Интерес);
	РезультатЗапроса = Запрос.Выполнить();
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Первое = Истина;
	
	Попытка
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			ВзаимодействиеОбъект = ВыборкаДетальныеЗаписи.Ссылка.ПолучитьОбъект();
			Если Первое Тогда
				ВзаимодействиеОбъект.Результат = РезультатТекущегоВзаимодействия;
				ВзаимодействиеОбъект.СостояниеИнтереса = Справочники.CRM_СостоянияИнтересов.ИнтересЗакрыт;
				ВзаимодействиеОбъект.ДатаЗавершенияВзаимодействия = ТекущаяДатаСеанса();
				ВзаимодействиеОбъект.ЗавершившийПользователь = Пользователи.ТекущийПользователь();
				ВзаимодействиеОбъект.ОжидаемаяВыручка = ОжидаемаяВыручкаУстановить;
				ВзаимодействиеОбъект.СтатусВзаимодействия = Справочники.CRM_СостоянияСобытий.Завершено;
				ВзаимодействиеОбъект.Записать();
				
				Если ЗначениеЗаполнено(ВзаимодействиеОбъект.Задача) Тогда
					ЗадачаОбъект = ВзаимодействиеОбъект.Задача.ПолучитьОбъект();
					ДатаСтрокой = CRM_БизнесПроцессыПереопределяемый.ПолучитьПредставлениеДатыДействия(ВзаимодействиеОбъект.ДатаЗавершенияВзаимодействия);
					
					ПоследнееДействиеСтрокой = ДатаСтрокой+" "+НСтр("ru = 'Завешнено взаимодействие"""+ВзаимодействиеОбъект.ВидВзаимодействия+""" -> '") + Строка(ВзаимодействиеОбъект.Ответственный);
					
					Если ПоследнееДействиеСтрокой = ЗадачаОбъект.CRM_ПоследнееДействиеСтрокой Тогда
						СтрокаДляЗамены = ПоследнееДействиеСтрокой + Символы.ПС + ВзаимодействиеОбъект.Результат + Символы.ПС;
						ЗадачаОбъект.РезультатВыполнения = СтрЗаменить(ЗадачаОбъект.РезультатВыполнения,ПоследнееДействиеСтрокой + Символы.ПС,СтрокаДляЗамены);
					Иначе
						ЗадачаОбъект.CRM_ПоследнееДействиеСтрокой = ПоследнееДействиеСтрокой;
						
						ЗадачаОбъект.РезультатВыполнения = ПоследнееДействиеСтрокой + Символы.ПС + ВзаимодействиеОбъект.Результат + ?(ПустаяСтрока(ЗадачаОбъект.РезультатВыполнения),"",Символы.ПС) + "
						|"+ЗадачаОбъект.РезультатВыполнения;
					КонецЕсли;
					ЗадачаОбъект.Записать();
					
					ПараметрыДосрочногоЗавершения = Новый Структура();
					ПараметрыДосрочногоЗавершения.Вставить("ЗавершенДосрочно"				,Истина);
					ПараметрыДосрочногоЗавершения.Вставить("ПричинаДосрочногоЗавершения"	,Справочники.CRM_ПричиныОтказов.ПустаяСсылка());
					ПараметрыДосрочногоЗавершения.Вставить("Задача"							,ЗадачаОбъект.Ссылка);
					ПараметрыДосрочногоЗавершения.Вставить("ЭтапДосрочногоЗавершения"	,ЗадачаОбъект.CRM_ТочкаМаршрута);
					ПараметрыДосрочногоЗавершения.Вставить("ВариантЗавершения"			,Справочники.CRM_ВариантыЗавершенияБизнесПроцесса.Успешно);
					
					CRM_БизнесПроцессыСервер.ЗавершитьДосрочноБизнесПроцесс(ПараметрыДосрочногоЗавершения);
				КонецЕсли;
			Иначе
				ВзаимодействиеОбъект.СтатусВзаимодействия = Справочники.CRM_СостоянияСобытий.Отменено;
				ВзаимодействиеОбъект.Записать();
			КонецЕсли;
			Первое = Ложь;
		КонецЦикла;
		
		ИнтересОбъект = Интерес.ПолучитьОбъект();
		ИнтересОбъект.ОжидаемаяВыручка = ОжидаемаяВыручкаУстановить;
		ИнтересОбъект.СостояниеИнтереса = Справочники.CRM_СостоянияИнтересов.ИнтересЗакрыт;
		ИнтересОбъект.Завершен = Истина;
		ИнтересОбъект.ДатаЗакрытия = ТекущаяДатаСеанса();
		ИнтересОбъект.Записать();
		
		Результат.Взаимодействие = Интерес;
		Результат.Успех = Истина;
	Исключение
		Результат.Взаимодействие = Неопределено;
		Результат.Успех = Ложь;
		Результат.Сообщение = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура Обработать(Команда)
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	Результат = ОбработатьИнтересНаСервере();
	Закрыть(Результат);
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	Закрыть();
КонецПроцедуры
