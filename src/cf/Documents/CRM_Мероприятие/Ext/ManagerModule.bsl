#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

	
// СтандартныеПодсистемы.ВерсионированиеОбъектов
// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
// Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт
КонецПроцедуры
// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	Представление = "Мероприятие " + Данные.Номер + " от "+ Формат(Данные.Дата, "ДФ='dd.MM.yyyy HH:mm'; ДЛФ=DT");
КонецПроцедуры

#КонецЕсли

//START Кайдашов 02/07/19
Функция ТекстЗапросаМероприятиеДанные()
	
	
	ТекстЗапроса = "ВЫБРАТЬ
	               |	CRM_Мероприятие.Ссылка КАК Ссылка,
	               |	CRM_Мероприятие.Номер КАК Номер,
	               |	CRM_Мероприятие.Дата КАК Дата,
	               |	CRM_Мероприятие.Автор КАК Автор,
	               |	CRM_Мероприятие.Ответственный КАК Ответственный,
	               |	CRM_Мероприятие.ОкончаниеМероприятия КАК ОкончаниеМероприятия,
	               |	CRM_Мероприятие.НаВесьДень КАК НаВесьДень,
	               |	CRM_Мероприятие.Подразделение КАК Подразделение,
	               |	CRM_Мероприятие.Помещение КАК Помещение,
	               |	CRM_Мероприятие.вогВидВзаимодействия КАК Вид,
	               |	CRM_Мероприятие.Тема КАК Тема,
	               |	CRM_Мероприятие.Место КАК Место,
	               |	CRM_Мероприятие.Инициатор КАК Инициатор
	               |ИЗ
	               |	Документ.CRM_Мероприятие КАК CRM_Мероприятие
	               |ГДЕ
	               |	CRM_Мероприятие.Ссылка В(&МассивОбъектов)
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	CRM_Мероприятие.Ссылка КАК Ссылка,
	               |	CRM_Мероприятие.Ответственный КАК Лицо,
	               |	CRM_Мероприятие.РольОтветственного КАК Роль
	               |ИЗ
	               |	Документ.CRM_Мероприятие КАК CRM_Мероприятие
	               |ГДЕ
	               |	CRM_Мероприятие.Ссылка В(&МассивОбъектов)
	               |
	               |ОБЪЕДИНИТЬ ВСЕ
	               |
	               |ВЫБРАТЬ
	               |	CRM_МероприятиеСвоиЛица.Ссылка,
	               |	CRM_МероприятиеСвоиЛица.Лицо,
	               |	CRM_МероприятиеСвоиЛица.Роль
	               |ИЗ
	               |	Документ.CRM_Мероприятие.СвоиЛица КАК CRM_МероприятиеСвоиЛица
	               |ГДЕ
	               |	CRM_МероприятиеСвоиЛица.Ссылка В(&МассивОбъектов)
	               |
	               |ОБЪЕДИНИТЬ ВСЕ
	               |
	               |ВЫБРАТЬ
	               |	CRM_МероприятиеСторонниеЛица.Ссылка,
	               |	CRM_МероприятиеСторонниеЛица.КонтактноеЛицо,
	               |	NULL
	               |ИЗ
	               |	Документ.CRM_Мероприятие.СторонниеЛица КАК CRM_МероприятиеСторонниеЛица
	               |ГДЕ
	               |	CRM_МероприятиеСторонниеЛица.Ссылка В(&МассивОбъектов)
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	CRM_МероприятиевогПрограмма.Ссылка КАК Ссылка,
	               |	CRM_МероприятиевогПрограмма.НомерСтроки КАК НомерСтроки,
	               |	CRM_МероприятиевогПрограмма.ВремяПлан КАК ВремяПлан,
	               |	CRM_МероприятиевогПрограмма.ВремяФакт КАК ВремяФакт,
	               |	CRM_МероприятиевогПрограмма.Исполнитель КАК Исполнитель,
	               |	CRM_МероприятиевогПрограмма.Комментарий КАК Комментарий,
	               |	CRM_МероприятиевогПрограмма.Начало КАК Начало,
	               |	CRM_МероприятиевогПрограмма.НомерПункта КАК НомерПункта,
	               |	CRM_МероприятиевогПрограмма.Окончание КАК Окончание,
	               |	CRM_МероприятиевогПрограмма.Содержание КАК Содержание,
	               |	CRM_МероприятиевогПрограмма.ТребуетПринятияРешения КАК ТребуетПринятияРешения,
	               |	CRM_МероприятиевогПрограмма.ОтКлиента КАК ОтКлиента
	               |ИЗ
	               |	Документ.CRM_Мероприятие.вогПрограмма КАК CRM_МероприятиевогПрограмма
	               |ГДЕ
	               |	CRM_МероприятиевогПрограмма.Ссылка В(&МассивОбъектов)
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	НомерПункта
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	вогПротоколыМероприятий.Мероприятие КАК Мероприятие,
	               |	вогПротоколыМероприятий.Решили КАК Решили,
	               |	вогПротоколыМероприятий.Слушали КАК Слушали,
	               |	вогПротоколыМероприятий.Выступили КАК Выступили,
	               |	вогПротоколыМероприятий.СрокОбработкиРезультатов КАК СрокОбработкиРезультатов,
	               |	вогПротоколыМероприятий.СрокИсполненияПроцесса КАК СрокИсполненияПроцесса,
	               |	вогПротоколыМероприятий.Ответственный КАК Ответственный,
	               |	вогПротоколыМероприятий.Проверяющий КАК Проверяющий,
	               |	вогПротоколыМероприятий.Ссылка КАК Ссылка,
	               |	CRM_МероприятиевогПротокол.НомерПунктаПрограммы КАК НомерПунктаПрограммы,
	               |	CRM_МероприятиевогПротокол.НомерСтроки КАК НомерСтроки
	               |ИЗ
	               |	Документ.CRM_Мероприятие.вогПротокол КАК CRM_МероприятиевогПротокол
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.вогПротоколыМероприятий КАК вогПротоколыМероприятий
	               |		ПО CRM_МероприятиевогПротокол.ПунктПротокола = вогПротоколыМероприятий.Ссылка
	               |			И CRM_МероприятиевогПротокол.НомерПунктаПрограммы = вогПротоколыМероприятий.НомерПунктаПрограммы
	               |ГДЕ
	               |	вогПротоколыМероприятий.Мероприятие В(&МассивОбъектов)
	               |	И НЕ вогПротоколыМероприятий.ПометкаУдаления
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	НомерСтроки";
	
	Возврат ТекстЗапроса;
	
	
КонецФункции

Процедура ВывестиСтрокуТаблицыСРазрывомСтраниц(ТабличныйДокумент,Макет,Повестка,Протокол,Ответственный)
	
	ПовесткаМассив = СтрРазделить(Повестка," ",Истина);
	ПротоколМассив = СтрРазделить(Протокол," ",Истина);
	ОтветственныйМассив = СтрРазделить(Ответственный," ",Истина);
	ОбластьСтрокаПовесткаРешения = Макет.ПолучитьОбласть("СтрокаПовесткаРешения");
	МаксДлина = Макс(ПовесткаМассив.Количество()-1,ПротоколМассив.Количество()-1,ОтветственныйМассив.Количество()-1);
	
	ПунктПовесткиПред = "";
	РешениеПред = "";
	ОтветсвПред = "";
	СтартовыйЭлемент = 0;
	
	Для счетчикСлов = 0 по МаксДлина цикл
		ПунктПовестки = "";
		Если ПовесткаМассив.Количество()-1>=счетчикСлов тогда
			ПунктПовестки = ПунктПовесткиПред +" "+ ПовесткаМассив[счетчикСлов];
		Иначе	
			ПунктПовестки = ПунктПовесткиПред;
		КонецЕсли;
		Решение = "";
		Если ПротоколМассив.Количество()-1>=счетчикСлов тогда
			Решение = РешениеПред +" "+ ПротоколМассив[счетчикСлов];
		Иначе	
			Решение = РешениеПред;
		КонецЕсли;
		Ответсв = "";
		Если ОтветственныйМассив.Количество()-1>=счетчикСлов тогда
			Ответсв = ОтветсвПред+" "+ ОтветственныйМассив[счетчикСлов];
		Иначе
			Ответсв = ОтветсвПред;
		КонецЕсли;
		ОбластьСтрокаПовесткаРешения.Параметры.ПунктПовестки = ПунктПовестки;
		ОбластьСтрокаПовесткаРешения.Параметры.Решение = Решение;
		ОбластьСтрокаПовесткаРешения.Параметры.Ответственный = Ответсв;
		Попытка
			Если ТабличныйДокумент.ПроверитьВывод(ОбластьСтрокаПовесткаРешения) = Ложь тогда
				ОбластьСтрокаПовесткаРешения.Параметры.ПунктПовестки = ПунктПовесткиПред;
				ОбластьСтрокаПовесткаРешения.Параметры.Решение = РешениеПред;
				ОбластьСтрокаПовесткаРешения.Параметры.Ответственный = ОтветсвПред;
				ТабличныйДокумент.Вывести(ОбластьСтрокаПовесткаРешения);
				ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
				счетчикСлов = счетчикСлов - 1;
				ПунктПовесткиПред = "";
				РешениеПред = "";
				ОтветсвПред = "";
			Иначе
				ПунктПовесткиПред = ПунктПовестки;
				РешениеПред = Решение;
				ОтветсвПред = Ответсв;
			КонецЕсли;
		Исключение
			//Возможно есть ошибка с принтерами, поэтому выводим всё
			ТабличныйДокумент.Вывести(ОбластьСтрокаПовесткаРешения);
			ОбластьСтрокаПовесткаРешения.Параметры.ПунктПовестки = Повестка;
			ОбластьСтрокаПовесткаРешения.Параметры.Решение = Протокол;
			ОбластьСтрокаПовесткаРешения.Параметры.Ответственный = Ответственный;
			ТабличныйДокумент.Вывести(ОбластьСтрокаПовесткаРешения);
			Возврат;	
		КонецПопытки;
	КонецЦикла;
	ОбластьСтрокаПовесткаРешения.Параметры.ПунктПовестки = ПунктПовесткиПред;
	ОбластьСтрокаПовесткаРешения.Параметры.Решение = РешениеПред;
	ОбластьСтрокаПовесткаРешения.Параметры.Ответственный = ОтветсвПред;
	ТабличныйДокумент.Вывести(ОбластьСтрокаПовесткаРешения);
	
КонецПроцедуры

Функция ПечатьКарточкаМероприятия(МассивОбъектов,ОбъектыПечати)  Экспорт
	
	
	Макет = Документы.CRM_Мероприятие.ПолучитьМакет("ПФ_MXL_КарточкаМероприятия");
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапросаМероприятиеДанные();
	Запрос.УстановитьПараметр("МассивОбъектов",МассивОбъектов);
	Результат = Запрос.ВыполнитьПакет();
	Данные = Результат[0].Выгрузить();
	Участники = Результат[1].Выгрузить();	
	Повестка = Результат[2].Выгрузить();	
	Протокол = Результат[3].Выгрузить();	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ВставитьРазрывСтраницы = Ложь;
	
	ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
	ОбластьЗаголовокУчастники = Макет.ПолучитьОбласть("ЗаголовокУчастники");
	ОбластьСтрокаУчастники = Макет.ПолучитьОбласть("СтрокаУчастники");
	ОбластьЗаголовокПовесткаРешения = Макет.ПолучитьОбласть("ЗаголовокПовесткаРешения");
	ОбластьСтрокаПовесткаРешения = Макет.ПолучитьОбласть("СтрокаПовесткаРешения");
	
	Для каждого Документ из Данные цикл
		
		ОбластьШапка.Параметры.ЗаголовокМероприятия = Строка(Документ.Вид);
		ОбластьШапка.Параметры.Тема = Документ.Тема;
		ОбластьШапка.Параметры.ДатаПроведения = Формат(Документ.Дата,"ДФ=dd.MM.yyyy");
		Если НЕ Документ.НаВесьДень тогда
			ОбластьШапка.Параметры.ВремяПроведения = Формат(Документ.Дата,"ДФ=HH.mm") + " - " + Формат(Документ.ОкончаниеМероприятия,"ДФ=HH.mm");
		Иначе	
			ОбластьШапка.Параметры.ВремяПроведения = "";
		КонецЕсли;
		ОбластьШапка.Параметры.МестоПроведения = Документ.Место;
		ОбластьШапка.Параметры.Инициатор = Документ.Инициатор;
		ОтборДокумент = Новый Структура;
		ОтборДокумент.Вставить("Ссылка",Документ.Ссылка);
		СтрокиУчастники = Участники.НайтиСтроки(ОтборДокумент);
		ТабличныйДокумент.Вывести(ОбластьШапка);
		ТабличныйДокумент.Вывести(ОбластьЗаголовокУчастники);
		Для каждого СтрокаУчастник из СтрокиУчастники цикл
			Если ЗначениеЗаполнено(СтрокаУчастник.Лицо) тогда
				ОбластьСтрокаУчастники.Параметры.Участник = СтрокаУчастник.Лицо;
				ОбластьСтрокаУчастники.Параметры.Роль =  СтрокаУчастник.Роль; 
				ТабличныйДокумент.Вывести(ОбластьСтрокаУчастники);
			КонецЕсли;
		КонецЦикла;
		ТабличныйДокумент.Вывести(ОбластьЗаголовокПовесткаРешения);
		
		СтрокиПовестка = Повестка.НайтиСтроки(ОтборДокумент);
		Если СтрокиПовестка.Количество()>0 тогда
			Для каждого СтрокаПовестки из СтрокиПовестка цикл
				ОтборПротокол = Новый Структура;
				ОтборПротокол.Вставить("Мероприятие",Документ.Ссылка);
				ОтборПротокол.Вставить("НомерПунктаПрограммы",СтрокаПовестки.НомерСтроки);
				СтрокиПротокола = Протокол.НайтиСтроки(ОтборПротокол);
				Сч=1;
				Для каждого СтрокаПротокола из СтрокиПротокола цикл
					ПунктПовестки = ?(СтрокаПовестки.Отклиента,"От клиента"+Символы.Пс+Символы.ВК ,"")+ "п."+СтрокаПовестки.НомерПункта+?(СтрокиПротокола.Количество()>1,"."+Сч,"")+" "+?(Сч=1,СтрокаПовестки.Содержание+Символы.ПС + Символы.ВК + СтрокаПовестки.Исполнитель,"");				
					Решение = СтрокаПротокола.Решили;
					Если ЗначениеЗаполнено(СтрокаПротокола.Ответственный) тогда
						Ответственный = Строка(СтрокаПротокола.Ответственный)+Символы.ПС + Символы.ВК +" до " + Формат(СтрокаПротокола.СрокИсполненияПроцесса,"ДФ=dd.MM.yyyy");				
					КонецЕсли;
					
					ВывестиСтрокуТаблицыСРазрывомСтраниц(ТабличныйДокумент,Макет,ПунктПовестки,Решение,Ответственный);
					
					Сч=Сч+1;	
				КонецЦикла;
				//Для каждого СтрокаПротокола из СтрокиПротокола цикл
				//	ОбластьСтрокаПовесткаРешения.Параметры.ПунктПовестки = ?(СтрокаПовестки.Отклиента,"От клиента","")+Символы.Пс+Символы.ВК + "п."+СтрокаПовестки.НомерПункта+?(СтрокиПротокола.Количество()>1,"."+Сч,"")+" "+?(Сч=1,СтрокаПовестки.Содержание+Символы.ПС + Символы.ВК + СтрокаПовестки.Исполнитель,"");				
				//	ОбластьСтрокаПовесткаРешения.Параметры.Решение = СтрокаПротокола.Решили;
				//	Если ЗначениеЗаполнено(СтрокаПротокола.Ответственный) тогда
				//		ОбластьСтрокаПовесткаРешения.Параметры.Ответственный = Строка(СтрокаПротокола.Ответственный)+Символы.ПС + Символы.ВК +" до " + Формат(СтрокаПротокола.СрокИсполненияПроцесса,"ДФ=dd.MM.yyyy");				
				//	КонецЕсли;
				//	ТабличныйДокумент.Вывести(ОбластьСтрокаПовесткаРешения);
				//	Сч=Сч+1;	
				//КонецЦикла;
				Если Сч=1 тогда
					ПунктПовестки = ?(СтрокаПовестки.Отклиента,"От клиента"+Символы.Пс+Символы.ВК,"")+ "п."+СтрокаПовестки.НомерПункта+" "+СтрокаПовестки.Содержание+Символы.ПС + Символы.ВК + СтрокаПовестки.Исполнитель;				
					Решение = "";
					Ответственный = "";
					ВывестиСтрокуТаблицыСРазрывомСтраниц(ТабличныйДокумент,Макет,ПунктПовестки,Решение,Ответственный);
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		//Выведем строки протокола которые не подвязаны к повестке
		Для каждого СтрокаПротокола из Протокол цикл
			Если СтрокаПротокола.НомерПунктаПрограммы = 0 тогда
				ПунктПовестки = "";				
				Решение = СтрокаПротокола.Решили;
				Если ЗначениеЗаполнено(СтрокаПротокола.Ответственный) тогда
					Ответственный = Строка(СтрокаПротокола.Ответственный)+Символы.ПС + Символы.ВК +" до " + Формат(СтрокаПротокола.СрокИсполненияПроцесса,"ДФ=dd.MM.yyyy");				
				Иначе
					Ответственный = "";
				КонецЕсли;
				ВывестиСтрокуТаблицыСРазрывомСтраниц(ТабличныйДокумент,Макет,ПунктПовестки,Решение,Ответственный);
			КонецЕсли;
		КонецЦикла;
		
	КонецЦикла;
	ТабличныйДокумент.АвтоМасштаб = Истина;
	Возврат ТабличныйДокумент;
	
КонецФункции

// Сформировать печатные формы объектов.
//
// ВХОДЯЩИЕ:
//   ИменаМакетов    - Строка    - Имена макетов, перечисленные через запятую.
//   МассивОбъектов  - Массив    - Массив ссылок на объекты которые нужно распечатать.
//   ПараметрыПечати - Структура - Структура дополнительных параметров печати.
//
// ИСХОДЯЩИЕ:
//   КоллекцияПечатныхФорм - Таблица значений - Сформированные табличные документы.
//   ПараметрыВывода       - Структура        - Параметры сформированных табличных документов.
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, 
	КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт

	ПараметрыВывода.ДоступнаПечатьПоКомплектно = Ложь;

	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "КарточкаМероприятия") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "КарточкаМероприятия", НСтр("ru = 'Карточка мероприятия'"), ПечатьКарточкаМероприятия(МассивОбъектов, ОбъектыПечати));
	КонецЕсли;
	
КонецПроцедуры


Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Обработчик = "вогОбщегоНазначенияКлиент.ПечатьКарточкиМероприятия";
	КомандаПечати.МенеджерПечати = "";
	КомандаПечати.Идентификатор = "КарточкаМероприятия";
	КомандаПечати.Представление = НСтр("ru = 'Карточка мероприятия'");
	КомандаПечати.СписокФорм = "ФормаДокумента"; 
	КомандаПечати.ПроверкаПроведенияПередПечатью = Ложь;
	
КонецПроцедуры


//END Кайдашов



//START Кайдашов 09/07/19 429
//Процедура обрабатывает нажатие кнопок в сообщениях связанных с документом Мероприятие
//Параметры:
//	Сообщение - Тип: СообщениеСистемыВзаимодействия
//	Действие - структура (см.описание в вогСистемаВзаимодействийКлиентСервер.ПолучитьПараметрыДействияКомандыСообщения())
Процедура ОбработкаКнопокСообщений(Действие,ИдентификаторСообщения) Экспорт
	   
	//Сообщение = СистемаВзаимодействия.ПолучитьСообщение(ИдентификаторСообщения);
	//Если Сообщение.Получатели.Содержит(СистемаВзаимодействия.ИдентификаторТекущегоПользователя()) тогда
	//	Если Действие.Команда = "ПринятьПриглашение" или Действие.Команда = "ОтклонитьПриглашение" тогда
	//		Попытка
	//			ЗаблокироватьДанныеДляРедактирования(Действие.Данные);
	//		Исключение
	//			Сообщение = Новый СообщениеПользователю;
	//			Сообщение.Текст = "Не удалось заблокировать документ мероприятие для изменения";
	//			Сообщение.УстановитьДанные(Действие.Данные);
	//			Сообщение.Сообщить();	
	//			Возврат;	
	//		КонецПопытки;
	//		
	//		ДокументОбъект = Действие.Данные.ПолучитьОбъект();
	//		Для каждого СтрокаСвоиЛица из ДокументОбъект.СвоиЛица цикл
	//			Если СтрокаСвоиЛица.Лицо = ПользователиКлиентСервер.ТекущийПользователь() тогда
	//				Если Действие.Команда = "ПринятьПриглашение" тогда
	//					СтрокаСвоиЛица.ПосетитМероприятие = 1;	
	//				ИначеЕсли Действие.Команда = "ОтклонитьПриглашение" тогда
	//					СтрокаСвоиЛица.ПосетитМероприятие = 0;	
	//				КонецЕсли;
	//			КонецЕсли;
	//		КонецЦикла;
	//		
	//		Попытка
	//			ДокументОбъект.Записать();
	//		Исключение
	//			Сообщение = Новый СообщениеПользователю;
	//			Сообщение.Текст = "Не удалось записать документ мероприятие "+Символы.ПС + Символы.ВК + ОписаниеОшибки();
	//			Сообщение.УстановитьДанные(Действие.Данные);
	//			Сообщение.Сообщить();	
	//			Возврат;	
	//		КонецПопытки;
	//		РазблокироватьДанныеДляРедактирования(Действие.Данные);
	//		УстановитьПривилегированныйРежим(Истина);
	//		СистемаВзаимодействия.УдалитьСообщение(Новый ИдентификаторСообщенияСистемыВзаимодействия(ИдентификаторСообщения));	
	//	КонецЕсли;
	//КонецЕсли;
	//
	
КонецПроцедуры

//END Кайдашов