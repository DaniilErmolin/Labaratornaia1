using System;
using System.Collections.Generic;

namespace lab2.Models;

public partial class TypesOfRecreation
{
    public int Id { get; set; }

    public string Name { get; set; } = null!;

    public string Description { get; set; } = null!;

    public string Restrictions { get; set; } = null!;

    public virtual ICollection<Voucher> Vouchers { get; set; } = new List<Voucher>();
}
