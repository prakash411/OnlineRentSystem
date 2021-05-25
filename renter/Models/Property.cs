using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace renter.Models
{
    public class Property
    {
        [Key]
        public int PropertyId { get; set; }

        [Required]
        public string OwnerName { get; set; }

        [Required]
        [Range(1, int.MaxValue)]
        public double Price { get; set; }

        [Required]
        public int BHK { get; set; }

        [Required]
        public string PropertyType { get; set; }

        [Required]
        public string Furnishing { get; set; }

        [Required]
        public int BathroomCount { get; set; }


        public string ShortDescription { get; set; }

        public string Description { get; set; }     

        public string Image { get; set; }


    }
}
