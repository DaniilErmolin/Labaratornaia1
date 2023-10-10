using System;
using System.Collections.Generic;

namespace lab2.Views;

public partial class RecreationView
{
    public int Id { get; set; }

    public string Name { get; set; } = null!;

    public string Description { get; set; } = null!;

    public string Restrictions { get; set; } = null!;
}
