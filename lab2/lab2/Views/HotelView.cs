﻿using System;
using System.Collections.Generic;

namespace lab2.Views;

public partial class HotelView
{
    public int Id { get; set; }

    public string Name { get; set; } = null!;

    public string Country { get; set; } = null!;

    public string City { get; set; } = null!;

    public string Address { get; set; } = null!;

    public string Phone { get; set; } = null!;

    public int Stars { get; set; }

    public string TheContactPerson { get; set; } = null!;

    public byte[] Photo { get; set; } = null!;
}
