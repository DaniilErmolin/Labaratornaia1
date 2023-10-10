using System;
using System.Collections.Generic;
using lab2.Models;
using lab2.Views;
using Microsoft.EntityFrameworkCore;

namespace lab2.DBContext;

public partial class TouristAgency1Context : DbContext
{
    public TouristAgency1Context()
    {
    }

    public TouristAgency1Context(DbContextOptions<TouristAgency1Context> options)
        : base(options)
    {
    }

    public virtual DbSet<AdditionalService> AdditionalServices { get; set; }

    public virtual DbSet<Client> Clients { get; set; }

    public virtual DbSet<Employee> Employees { get; set; }

    public virtual DbSet<Hotel> Hotels { get; set; }

    public virtual DbSet<HotelView> HotelViews { get; set; }

    public virtual DbSet<RecreationView> RecreationViews { get; set; }

    public virtual DbSet<TypesOfRecreation> TypesOfRecreations { get; set; }

    public virtual DbSet<Voucher> Vouchers { get; set; }

    public virtual DbSet<VoucherView> VoucherViews { get; set; }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
#warning To protect potentially sensitive information in your connection string, you should move it out of source code. You can avoid scaffolding the connection string by using the Name= syntax to read it from configuration - see https://go.microsoft.com/fwlink/?linkid=2131148. For more guidance on storing connection strings, see http://go.microsoft.com/fwlink/?LinkId=723263.
        => optionsBuilder.UseSqlServer("Server=DESKTOP-RC1TE3C;Database=TouristAgency1;Trusted_Connection=True; TrustServerCertificate=True;");

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<AdditionalService>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Addition__3214EC07BC28C93C");

            entity.Property(e => e.Description).HasMaxLength(200);
            entity.Property(e => e.Name).HasMaxLength(50);
            entity.Property(e => e.Price).HasColumnType("money");
        });

        modelBuilder.Entity<Client>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Clients__3214EC0709F595A5");

            entity.Property(e => e.Address).HasMaxLength(100);
            entity.Property(e => e.DateOfBirth).HasColumnType("date");
            entity.Property(e => e.Fio)
                .HasMaxLength(150)
                .HasColumnName("FIO");
            entity.Property(e => e.Series).HasMaxLength(50);
            entity.Property(e => e.Sex).HasMaxLength(50);
        });

        modelBuilder.Entity<Employee>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Employee__3214EC077EB2F5F7");

            entity.Property(e => e.Fio)
                .HasMaxLength(150)
                .HasColumnName("FIO");
            entity.Property(e => e.JobTitle).HasMaxLength(50);
        });

        modelBuilder.Entity<Hotel>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Hotels__3214EC07F9846FAA");

            entity.Property(e => e.Address).HasMaxLength(100);
            entity.Property(e => e.City).HasMaxLength(50);
            entity.Property(e => e.Country).HasMaxLength(50);
            entity.Property(e => e.Name).HasMaxLength(50);
            entity.Property(e => e.Phone).HasMaxLength(20);
            entity.Property(e => e.Photo).HasColumnType("image");
            entity.Property(e => e.TheContactPerson).HasMaxLength(100);
        });

        modelBuilder.Entity<HotelView>(entity =>
        {
            entity
                .HasNoKey()
                .ToView("HotelView");

            entity.Property(e => e.Address).HasMaxLength(100);
            entity.Property(e => e.City).HasMaxLength(50);
            entity.Property(e => e.Country).HasMaxLength(50);
            entity.Property(e => e.Id).ValueGeneratedOnAdd();
            entity.Property(e => e.Name).HasMaxLength(50);
            entity.Property(e => e.Phone).HasMaxLength(20);
            entity.Property(e => e.Photo).HasColumnType("image");
            entity.Property(e => e.TheContactPerson).HasMaxLength(100);
        });

        modelBuilder.Entity<RecreationView>(entity =>
        {
            entity
                .HasNoKey()
                .ToView("RecreationView");

            entity.Property(e => e.Description).HasMaxLength(100);
            entity.Property(e => e.Id).ValueGeneratedOnAdd();
            entity.Property(e => e.Name).HasMaxLength(50);
            entity.Property(e => e.Restrictions).HasMaxLength(50);
        });

        modelBuilder.Entity<TypesOfRecreation>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__TypesOfR__3214EC07C89167FD");

            entity.ToTable("TypesOfRecreation");

            entity.Property(e => e.Description).HasMaxLength(100);
            entity.Property(e => e.Name).HasMaxLength(50);
            entity.Property(e => e.Restrictions).HasMaxLength(50);
        });

        modelBuilder.Entity<Voucher>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Vouchers__3214EC07A43B24A5");

            entity.Property(e => e.ExpirationDate).HasColumnType("date");
            entity.Property(e => e.StartDate).HasColumnType("date");

            entity.HasOne(d => d.AdditionalService).WithMany(p => p.Vouchers)
                .HasForeignKey(d => d.AdditionalServiceId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Vouchers_AdditionalServices");

            entity.HasOne(d => d.Client).WithMany(p => p.Vouchers)
                .HasForeignKey(d => d.ClientId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Vouchers_Clients");

            entity.HasOne(d => d.Employess).WithMany(p => p.Vouchers)
                .HasForeignKey(d => d.EmployessId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Vouchers_Employees");

            entity.HasOne(d => d.Hotel).WithMany(p => p.Vouchers)
                .HasForeignKey(d => d.HotelId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Vouchers_Hotels");

            entity.HasOne(d => d.TypeOfRecreation).WithMany(p => p.Vouchers)
                .HasForeignKey(d => d.TypeOfRecreationId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Vouchers_TypesOfRecreation");
        });

        modelBuilder.Entity<VoucherView>(entity =>
        {
            entity
                .HasNoKey()
                .ToView("VoucherView");

            entity.Property(e => e.AdditionalService).HasMaxLength(50);
            entity.Property(e => e.ClientName).HasMaxLength(150);
            entity.Property(e => e.EmployeeName).HasMaxLength(150);
            entity.Property(e => e.ExpirationDate).HasColumnType("date");
            entity.Property(e => e.HotelName).HasMaxLength(50);
            entity.Property(e => e.RecreationType).HasMaxLength(50);
            entity.Property(e => e.StartDate).HasColumnType("date");
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
