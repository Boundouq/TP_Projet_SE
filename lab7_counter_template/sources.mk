#/*======================================================================*/
#   TIMA LABORATORY                                                      
#/*======================================================================*/
#/*======================================================================*/
#   Noureddine Ait Said
#   PhD Student - TIMA Laboratory
#   nouredddine.ait-said@univ-grenoble-alpes.fr
#/*======================================================================*/

SRC_DIR=./src
BUILD_DIR=.

SOURCES = $(SRC_DIR)/entry.S \
			$(SRC_DIR)/main.c \
			$(SRC_DIR)/syscalls.c \
			$(SRC_DIR)/trap_handler.c \
			$(SRC_DIR)/plic_counter.c

INCLUDES = -I./include
