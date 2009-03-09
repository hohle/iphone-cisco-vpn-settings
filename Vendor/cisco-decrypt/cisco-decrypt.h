/* Decoder for password encoding of Cisco VPN client.
 Copyright (C) 2005 Maurice Massar
 Thanks to HAL-9000@evilscientists.de for decoding and posting the algorithm!
 
 This program is free software; you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation; either version 2 of the License, or
 (at your option) any later version.
 
 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with this program; if not, write to the Free Software
 Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */

/* converts a hex string to binary */
int hex2bin(const char *str, char **bin, int *len);

/* decrypts a binary password */
int c_decrypt(char *ct, int len, char **resp, char *reslenp);
