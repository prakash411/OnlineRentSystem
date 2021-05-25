using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace renter.Models
{
    public class Booking
    {
        [Key]
        public int BookingId { get; set; }

        [Required]
        public string OwnerName { get; set; }

        [Required]
        public string CustomerName { get; set; }

        [Required]
        public string CustomerNumber { get; set; }

        [Required]
        public string CustomerEmail { get; set; }

        public string BookingStatus { get; set; }

        [Required]
        public int PropertyId { get; set; }
    }
}
