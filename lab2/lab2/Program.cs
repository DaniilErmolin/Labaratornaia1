using lab2.DBContext;
using lab2.Models;
using System;
using System.Collections.Generic;
using System.Diagnostics.Contracts;
using System.Linq;
using System.Text;
using System.Threading.Tasks;


namespace TouristAgency
{
    internal class Program
    {
        static void Main(string[] args)
        {
            while (true)
            {
                Console.WriteLine("Выберите действие:");
                Console.WriteLine("1. Выборка всех сотрудников");
                Console.WriteLine("2. Выборка сотрудников с возрастом не больше 30");
                Console.WriteLine("3. Вывести группированные данные о дополнительных услугах");
                Console.WriteLine("4. Вывести дополнительные услуги по датам начала и конца");
                Console.WriteLine("5. Вывести данные о путёвках, где дополнительные услуги стоят свыше 10");
                Console.WriteLine("6. Добавить нового клиента");
                Console.WriteLine("7. Добавить путёвку");
                Console.WriteLine("8. Удалить клиента");
                Console.WriteLine("9. Удалить путёвку");
                Console.WriteLine("10. Обновить цены на услуги");

                int choice;
                if (int.TryParse(Console.ReadLine(), out choice))
                {
                    switch (choice)
                    {
                        case 1:
                            AllEmployees();
                            break;
                        case 2:
                            EmployeesBelowAge();
                            break;
                        case 3:
                            GroupedServicesByPrice();
                            break;
                        case 4:
                            ServiceVouchers();
                            break;
                        case 5:
                            VouchersWithHighValueDeals();
                            break;
                        case 6:
                            AddNewClient();
                            break;
                        case 7:
                            AddNewVoucher();
                            break;
                        case 8:
                            DeleteClient();
                            break;
                        case 9:
                            DeleteVoucher();
                            break;
                        case 10:
                            UpdateAdditionalServicePrices();
                            break;
                        default:
                            Console.WriteLine("Неверный выбор. Пожалуйста, выберите снова.");
                            break;
                    }
                }
                else
                {
                    Console.WriteLine("Неверный ввод. Пожалуйста, выберите снова.");
                }
            }

        }
        static void AllEmployees()
        {
            using (var context = new TouristAgency1Context()) // Вывод данных о сотрудниках
            {
                var employees = context.Employees.ToList();

                if (employees.Count > 0)
                {
                    Console.WriteLine("Вся информация о сотрудниках:");
                    foreach (var employee in employees)
                    {
                        Console.WriteLine($"ID: {employee.Id} | ФИО: {employee.Fio} | Должность: {employee.JobTitle} | Возраст: {employee.Age}");
                    }
                }
                else
                {
                    Console.WriteLine("Сотрудники не найдены.");
                }
            }
        }

        static void EmployeesBelowAge()
        {
            using (var context = new TouristAgency1Context()) // Вывод сотрудников с возрастом не больше 30
            {
                var selectedEmployees = context.Employees
                    .Where(employee => employee.Age <= 30)
                    .ToList();

                if (selectedEmployees.Count > 0)
                {
                    Console.WriteLine($"Сотрудники с возрастом не больше 30 лет:");
                    foreach (var employee in selectedEmployees)
                    {
                        Console.WriteLine($"ID: {employee.Id} | ФИО: {employee.Fio} | Должность: {employee.JobTitle} | Возраст: {employee.Age}");
                    }
                }
                else
                {
                    Console.WriteLine($"Сотрудники с возрастом не больше 30 лет не найдены.");
                }
            }
        }

        static void GroupedServicesByPrice()
        {
            using (var context = new TouristAgency1Context()) // Группирует по цене дополнительных услуг
            {
                var groupedServices = context.AdditionalServices
                    .GroupBy(service => service.Price)
                    .Select(group => new
                    {
                        Price = group.Key,
                        MaxPrice = group.Max(service => service.Price),
                        Count = group.Count()
                    })
                    .ToList();

                foreach (var group in groupedServices)
                {
                    Console.WriteLine($"Цена услуги: {group.Price.ToString("N2")} | Максимальная цена: {group.MaxPrice.ToString("N2")} | Количество услуг: {group.Count}");
                }
            }
        }

        static void ServiceVouchers()
        {
            using (var context = new TouristAgency1Context()) // Вывод дополнительных услуг с их началом и концом
            {
                var serviceVouchers = context.AdditionalServices
                    .SelectMany(service => service.Vouchers, (service, voucher) => new
                    {
                        ServiceName = service.Name,
                        StartDate = voucher.StartDate.ToShortDateString(),
                        ExpirationDate = voucher.ExpirationDate.ToShortDateString()
                    })
                    .ToList();

                foreach (var entry in serviceVouchers)
                {
                    Console.WriteLine($"Услуга: {entry.ServiceName}, Дата начала: {entry.StartDate}, Дата истечения: {entry.ExpirationDate}");
                }
            }
        }

        static void VouchersWithHighValueDeals()
        {
            using (var context = new TouristAgency1Context()) // Вывод данных о путёвках, где дополнительные услуги стоят свыше 10
            {
                decimal minimumDealAmount = 10.0m;

                var vouchersWithHighValueDeals = context.Vouchers
                    .Where(voucher =>
                        voucher.AdditionalService.Price > minimumDealAmount)
                    .ToList();

                foreach (var voucher in vouchersWithHighValueDeals)
                {
                    Console.WriteLine($"Путёвка с дополнительными услугами, стоимость которых свыше {minimumDealAmount:N2} | Номер путёвки: {voucher.Id}");
                }
            }
        }

        static void AddNewClient()
        {
            using (var context = new TouristAgency1Context()) // Добавление нового клиента
            {
                var newClient = new Client
                {
                    Fio = "Король Василий",
                    DateOfBirth = new DateTime(1990, 1, 1), // Замените эту дату на дату рождения клиента
                    Sex = "Мужской", // Замените на пол клиента
                    Address = "Адрес клиента",
                    Series = "HB", // Замените на серию паспорта клиента
                    Number = 1234567890, // Замените на номер паспорта клиента
                    Discount = 10 // Замените на размер скидки клиента
                };

                context.Clients.Add(newClient);
                context.SaveChanges();

                Console.WriteLine("Новый клиент успешно добавлен.");
            }
        }

        static void AddNewVoucher()
        {
            using (var context = new TouristAgency1Context()) // Добавление новой записи в путёвки
            {
                var newVoucher = new Voucher
                {
                    StartDate = DateTime.Now,
                    ExpirationDate = DateTime.Now.AddDays(30),
                    HotelId = 1, // Замените на ID отеля
                    TypeOfRecreationId = 1, // Замените на ID типа рекреации
                    AdditionalServiceId = 1, // Замените на ID дополнительной услуги
                    ClientId = 1, // Замените на ID клиента
                    EmployessId = 1, // Замените на ID сотрудника
                    Reservation = true, // Замените на нужное значение
                    Payment = false, // Замените на нужное значение
                };

                context.Vouchers.Add(newVoucher); // Добавление новой путёвки в контекст базы данных
                context.SaveChanges(); // Сохранение изменений

                Console.WriteLine("Новая путёвка успешно создана.");
            }
        }


        static void DeleteClient()
        {
            using (var context = new TouristAgency1Context()) // Удаление записи по фамилии
            {
                var clientToDelete = context.Clients.FirstOrDefault(c => c.Fio == "Король Василий");

                if (clientToDelete != null)
                {
                    context.Clients.Remove(clientToDelete); // Удаление клиента из контекста базы данных
                    context.SaveChanges(); // Сохранение изменений

                    Console.WriteLine("Клиент успешно удален.");
                }
                else
                {
                    Console.WriteLine("Клиент не найден.");
                }
            }
        }



        static void DeleteVoucher()
        {
            using (var context = new TouristAgency1Context()) // Удаление записи из таблицы Voucher
            {
                var voucherToDelete = context.Vouchers.FirstOrDefault(v => v.Id == 53);

                if (voucherToDelete != null)
                {
                    context.Vouchers.Remove(voucherToDelete); // Удаление путёвки из контекста базы данных
                    context.SaveChanges(); // Сохранение изменений

                    Console.WriteLine("Путёвка успешна удалена.");
                }
                else
                {
                    Console.WriteLine("Путёвка не найден.");
                }
            }
        }


        static void UpdateAdditionalServicePrices()
        {
            using (var context = new TouristAgency1Context()) // Изменение стоимости услуги
            {
                var servicesToUpdate = context.AdditionalServices.Where(service => service.Price < 10);

                foreach (var service in servicesToUpdate)
                {
                    service.Price *= 1.2m;
                }

                context.SaveChanges();

                Console.WriteLine("Цены на услуги успешно обновлены.");
            }
        }


    }

}
