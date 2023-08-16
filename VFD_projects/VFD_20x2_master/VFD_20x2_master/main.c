/*
 * VFD_20x2_master.c
 *
 * Created: 23.04.2023 14:57:41
 * Author : User
 */ 



#include "config.h"
#include <avr/io.h>
#include <util/delay.h>
#include <avr/interrupt.h>
#include <avr/sleep.h>
#include <stdbool.h>


#include "string.h"
#include "lib/uart_hal.h"
#include "lib/gpio_driver.h"
#include "lib/twi_hal.h"
#include "lib/timer1_hal.h"
#include "lib/vfd_driver.h"


uint8_t expander_data[] = {0x00 , 0xAA};
#define EXPANDER_ADDR  	0x22
#define EXPANDER_REG  	0x00
uint8_t led_port = 0;

gpio vfd_reset = {(uint8_t *)&PORTC , PORTC1}; 
gpio vfd_cs = {(uint8_t *)&PORTC , PORTC0};
gpio vfd_stb = {(uint8_t *)&PORTB , PORTB0};
gpio vfd_mosi = {(uint8_t *)&PORTB , PORTB3};
gpio vfd_clk = {(uint8_t *)&PORTB , PORTB5};
gpio vfd_40v = {(uint8_t *)&PORTD , PORTD5};

	
gpio grn_led = {(uint8_t *)&led_port , PORTC0};
gpio red_led = {(uint8_t *)&led_port , PORTC1};	
gpio orange_led = {(uint8_t *)&led_port , PORTC2};

display vfd = {.first_line = "not initialized     ",
			.second_line = "03/07/2023   {38400}",
			.ld_green = 2,
			.ld_orange = 2,
			.ld_red = 2
};




int main(void)
{
   
   
   sei();
   uart_init(38400,0);
   twi_init(400000);
   //char char_array[128]="\0";
   
   //DDRC = 255;
   set_pin_dir(&vfd_reset , PORT_DIR_OUT);	set_pin_level(&vfd_reset , false);
   set_pin_dir(&vfd_cs , PORT_DIR_OUT);		set_pin_level(&vfd_cs , true);
   set_pin_dir(&vfd_stb , PORT_DIR_OUT);	set_pin_level(&vfd_stb , false);
   set_pin_dir(&vfd_mosi , PORT_DIR_OUT);	set_pin_level(&vfd_mosi , false);
   set_pin_dir(&vfd_clk , PORT_DIR_OUT);	set_pin_level(&vfd_clk , true);
   set_pin_dir(&vfd_40v , PORT_DIR_OUT);	set_pin_level(&vfd_40v , true);
   _delay_ms(500);
   timer1_init(0);
   uint8_t blink_divider = 0;
   
   
   
   
   vfd_init();
  
   
   while (1) 
   {



	if (serial_complete()){
		const char *data_p = serial_read_data();
		parseString(data_p, &vfd);
	}






	_delay_ms(25);
	blink_divider++;
	if (blink_divider >= 15){
		blink_divider = 0;
		vfd_set_cursor(1,0);
		vfd_string((uint8_t *)vfd.first_line);
		vfd_set_cursor(2,0);
		vfd_string((uint8_t *)vfd.second_line);
		//sprintf(char_array, "%d; ", led_port);			
		//vfd_set_cursor(1,0);
		//vfd_string((uint8_t *)char_array);
		    switch (vfd.ld_orange) {
			    case 1:
			    set_pin_level(&orange_led, false);
			    break;
			    case 2:
			    toggle_bit_level(&orange_led);
			    break;
			    default:
			    set_pin_level(&orange_led, true);
			    break;
		    }
			 switch (vfd.ld_green) {
				 case 1:
				 set_pin_level(&grn_led, false);
				 break;
				 case 2:
				 toggle_bit_level(&grn_led);
				 break;
				 default:
				 set_pin_level(&grn_led, true);
				 break;
			 }
			 switch (vfd.ld_red) {
				 case 1:
				 set_pin_level(&red_led, false);
				 break;
				 case 2:
				 toggle_bit_level(&red_led);
				 break;
				 default:
				 set_pin_level(&red_led, true);
				 break;
			 }
		
		expander_data[0] = led_port;
		twi_write(EXPANDER_ADDR , EXPANDER_REG, expander_data, sizeof(expander_data));
		
	
	}}
}

