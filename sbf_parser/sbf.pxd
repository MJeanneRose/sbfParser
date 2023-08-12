# JEANNE-ROSE Méven
# 08/2023

from libc.stdint cimport uint16_t

cdef extern from "c_crc.h":
    uint16_t crc16(const void*, size_t, uint16_t)
