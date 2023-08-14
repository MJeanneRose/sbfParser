# Initial code by Jashandeep Sohi (2013, jashandeep.s.sohi@gmail.com)
# adapted by Marco Job (2019, marco.job@bluewin.ch)
# Update Meven Jeanne-Rose 2023

from .blocks import BLOCKNAMES, BLOCKNUMBERS
from .parsers cimport BLOCKPARSERS

from libc.stdint cimport uint16_t, uint8_t
from libc.stdio cimport fread, fdopen, FILE, fseek, SEEK_CUR
from libc.stdlib cimport malloc, free

HEADER_LEN = 8

cdef struct Header:
    uint16_t Sync
    uint16_t CRC
    uint16_t ID
    uint16_t Length


def load(fobj, blocknames=[]):
    try:
        fileno = fobj.fileno()
    except:
        raise Exception('Could not obtain fileno from file-like object')

    cdef Header h
    cdef FILE * f = fdopen(fileno, 'rb')
    cdef uint16_t blockno
    cdef void * body_ptr
    cdef size_t body_length

    num_name_dict = dict(zip(BLOCKNUMBERS, BLOCKNAMES))
    
    blockparsers = {x: BLOCKPARSERS.get(x, BLOCKPARSERS['Unknown']) for x in set(num_name_dict.viewvalues())}

    if not blockparsers:
        print("Unable to create parsers")
        return()

    try:
        while True:
            if not fread(&h, HEADER_LEN, 1, f):
                break
            if h.Sync == 16420:
                if h.Length > HEADER_LEN and h.Length % 4 == 0:
                    body_length = h.Length - HEADER_LEN

                    body_ptr = malloc(body_length)

                    if not fread(body_ptr, body_length, 1, f):
                        break

                    # Check crc
                    if h.CRC == crc16(body_ptr, body_length, crc16( & (h.ID), 4, 0)):
                        blockno = h.ID & 0x1fff
                        blockrev = (h.ID & 0xE000) >> 13
                        blockname = num_name_dict.get(blockno, 'Unknown')
                        parser_func = blockparsers.get(blockname)
                        if parser_func:
                            block_dict = parser_func(( <char*>body_ptr)[0:body_length], blockrev)
                            yield blockname, block_dict

                    else:
                        fseek(f, -HEADER_LEN + 1 - body_length, SEEK_CUR)

                    free(body_ptr)

                else:
                    # Length is not > header, try again
                    fseek(f, -HEADER_LEN + 1, SEEK_CUR)
                    continue
            else:
                # We did not find sync, go back 7 bytes and try again
                fseek(f, -HEADER_LEN + 1, SEEK_CUR)
                continue
    except Exception as e:
        print(e)
