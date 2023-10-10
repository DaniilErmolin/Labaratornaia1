using System;
using System.Collections.Generic;

namespace lab2.Views;

public partial class VoucherView
{
    public int VoucherId { get; set; }

    public DateTime StartDate { get; set; }

    public DateTime ExpirationDate { get; set; }

    public string HotelName { get; set; } = null!;

    public string ClientName { get; set; } = null!;

    public string EmployeeName { get; set; } = null!;

    public string RecreationType { get; set; } = null!;

    public string AdditionalService { get; set; } = null!;

    public bool Reservation { get; set; }

    public bool Payment { get; set; }
}
