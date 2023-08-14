# Initial code by Jashandeep Sohi (2013, jashandeep.s.sohi@gmail.com)
# adapted by Marco Job (2019, marco.job@bluewin.ch)
# Update Meven Jeanne-Rose 2023

cdef dict BLOCKPARSERS = dict()


def unknown_toDict(c1 * data):
    return dict()


BLOCKPARSERS['Unknown'] = unknown_toDict


def MeasEpoch_toDict(c1 * data):
    cdef MeasEpoch * sb0
    cdef MeasEpoch_Type_1 * sb1
    cdef MeasEpoch_Type_2 * sb2
    cdef size_t i

    cdef MeasEpoch_Type_1 ** sb1s
    cdef MeasEpoch_Type_2 ** *sb2s

    sb0 = <MeasEpoch * >data
    i = sizeof(MeasEpoch)

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['N1'] = sb0.N1
    block_dict['SB1Length'] = sb0.SB1Length
    block_dict['SB2Length'] = sb0.SB2Length
    block_dict['CommonFlags'] = sb0.CommonFlags
    block_dict['CumClkJumps'] = sb0.CumClkJumps

    sb1s = <MeasEpoch_Type_1 ** >malloc(sb0.N1 * sizeof(MeasEpoch_Type_1 * ) )
    sb2s = <MeasEpoch_Type_2 ** * > malloc(sb0.N1 * sizeof(MeasEpoch_Type_1 * ) )

    sb1_list = [None] * sb0.N1
    block_dict['Type1'] = sb1_list

    for n1 in xrange(sb0.N1):
        sb1 = sb1s[n1] = <MeasEpoch_Type_1*>(data + i)
        i += sb0.SB1Length
        sb1_dict = dict()
        sb1_list[n1] = sb1_dict
        sb1_dict['RxChannel'] = sb1.RxChannel
        sb1_dict['Type'] = sb1.Type
        sb1_dict['SVID'] = sb1.SVID
        sb1_dict['Misc'] = sb1.Misc
        sb1_dict['CodeLSB'] = sb1.CodeLSB
        sb1_dict['Doppler'] = sb1.Doppler
        sb1_dict['CarrierLSB'] = sb1.CarrierLSB
        sb1_dict['CarrierMSB'] = sb1.CarrierMSB
        sb1_dict['CN0'] = sb1.CN0
        sb1_dict['LockTime'] = sb1.LockTime
        sb1_dict['ObsInfo'] = sb1.ObsInfo
        sb1_dict['N2'] = sb1.N2

        sb2s[n1] = <MeasEpoch_Type_2 ** >malloc(sb1.N2 * sizeof(MeasEpoch_Type_2 * ) )
        sb2_list = [None] * sb1.N2
        sb1_dict['Type2'] = sb2_list

        for n2 in xrange(sb1.N2):
            sb2 = sb2s[n1][n2] = <MeasEpoch_Type_2*>(data + i)
            i += sb0.SB2Length
            sb2_dict = dict()
            sb2_list[n2] = sb2_dict
            sb2_dict['Type'] = sb2.Type
            sb2_dict['LockTime'] = sb2.LockTime
            sb2_dict['CN0'] = sb2.CN0
            sb2_dict['OffsetMSB'] = sb2.OffsetMSB
            sb2_dict['CarrierMSB'] = sb2.CarrierMSB
            sb2_dict['ObsInfo'] = sb2.ObsInfo
            sb2_dict['CodeOffsetLSB'] = sb2.CodeOffsetLSB
            sb2_dict['CarrierLSB'] = sb2.CarrierLSB
            sb2_dict['DopplerOffsetLSB'] = sb2.DopplerOffsetLSB

        free(sb2s[n1])
    free(sb2s)
    free(sb1s)
    return block_dict


BLOCKPARSERS['MeasEpoch'] = MeasEpoch_toDict


def MeasExtra_toDict(c1 * data):
    cdef MeasExtra * sb0
    cdef MeasExtraChannelSub * sb1
    cdef size_t i

    cdef MeasExtraChannelSub ** sb1s

    sb0 = <MeasExtra * >data
    i = sizeof(MeasExtra)

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['N'] = sb0.N
    block_dict['SBLength'] = sb0.SBLength
    block_dict['DopplerVarFactor'] = sb0.DopplerVarFactor

    sb1s = <MeasExtraChannelSub ** >malloc(sb0.N * sizeof(MeasExtraChannelSub * ) )

    sb1_list = [None] * sb0.N
    block_dict['MeasExtraChannel'] = sb1_list

    for n in xrange(sb0.N):
        sb1 = sb1s[n] = <MeasExtraChannelSub*>(data + i)
        i += sb0.SBLength
        sb1_dict = dict()
        sb1_list[n] = sb1_dict
        sb1_dict['RxChannel'] = sb1.RxChannel
        sb1_dict['Type'] = sb1.Type
        sb1_dict['MPCorrection '] = sb1.MPCorrection
        sb1_dict['SmoothingCorr'] = sb1.SmoothingCorr
        sb1_dict['CodeVar'] = sb1.CodeVar
        sb1_dict['CarrierVar'] = sb1.CarrierVar
        sb1_dict['LockTime'] = sb1.LockTime
        sb1_dict['CumLossCont'] = sb1.CumLossCont
        sb1_dict['Info'] = sb1.Info

    free(sb1s)
    return block_dict


BLOCKPARSERS['MeasExtra'] = MeasExtra_toDict


def EndOfMeas_toDict(c1 * data):
    cdef EndOfMeas * sb0
    sb0 = <EndOfMeas * >data

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc

    return block_dict


BLOCKPARSERS['EndOfMeas'] = EndOfMeas_toDict


def GPSRawCA_toDict(c1 * data):
    cdef GPSRawCA * sb0
    sb0 = <GPSRawCA * >data

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['SVID'] = sb0.SVID
    block_dict['CRCPassed'] = sb0.CRCPassed
    block_dict['ViterbiCount'] = sb0.ViterbiCount
    block_dict['Source'] = sb0.Source
    block_dict['FreqNr'] = sb0.FreqNr
    block_dict['RxChannel'] = sb0.RxChannel
    block_dict['NAVBits'] = (< c1*>sb0.NAVBits)[0:40]

    return block_dict


BLOCKPARSERS['GPSRawCA'] = GPSRawCA_toDict


def GPSRawL2C_toDict(c1 * data):
    cdef GPSRawL2C * sb0
    sb0 = <GPSRawL2C * >data

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['SVID'] = sb0.SVID
    block_dict['CRCPassed'] = sb0.CRCPassed
    block_dict['ViterbiCount'] = sb0.ViterbiCount
    block_dict['Source'] = sb0.Source
    block_dict['FreqNr'] = sb0.FreqNr
    block_dict['RxChannel'] = sb0.RxChannel
    block_dict['NAVBits'] = (< c1*>sb0.NAVBits)[0:40]

    return block_dict


BLOCKPARSERS['GPSRawL2C'] = GPSRawL2C_toDict


def GPSRawL5_toDict(c1 * data):
    cdef GPSRawL5 * sb0
    sb0 = <GPSRawL5 * >data

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['SVID'] = sb0.SVID
    block_dict['CRCPassed'] = sb0.CRCPassed
    block_dict['ViterbiCount'] = sb0.ViterbiCount
    block_dict['Source'] = sb0.Source
    block_dict['FreqNr'] = sb0.FreqNr
    block_dict['RxChannel'] = sb0.RxChannel
    block_dict['NAVBits'] = (< c1*>sb0.NAVBits)[0:40]

    return block_dict


BLOCKPARSERS['GPSRawL5'] = GPSRawL5_toDict


def GLORawCA_toDict(c1 * data):
    cdef GLORawCA * sb0
    sb0 = <GLORawCA * >data

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['SVID'] = sb0.SVID
    block_dict['CRCPassed'] = sb0.CRCPassed
    block_dict['ViterbiCount'] = sb0.ViterbiCount
    block_dict['Source'] = sb0.Source
    block_dict['FreqNr'] = sb0.FreqNr
    block_dict['RxChannel'] = sb0.FreqNr
    block_dict['NAVBits'] = (< c1*>sb0.NAVBits)[0:12]

    return block_dict


BLOCKPARSERS['GLORawCA'] = GLORawCA_toDict


def GALRawFNAV_toDict(c1 * data):
    cdef GALRawFNAV * sb0
    sb0 = <GALRawFNAV * >data

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['SVID'] = sb0.SVID
    block_dict['CRCPassed'] = sb0.CRCPassed
    block_dict['ViterbiCount'] = sb0.ViterbiCount
    block_dict['Source'] = sb0.Source
    block_dict['FreqNr'] = sb0.FreqNr
    block_dict['RxChannel'] = sb0.RxChannel
    block_dict['NAVBits'] = (< c1*>sb0.NAVBits)[0:32]

    return block_dict


BLOCKPARSERS['GALRawFNAV'] = GALRawFNAV_toDict


def GALRawINAV_toDict(c1 * data):
    cdef GALRawINAV * sb0
    sb0 = <GALRawINAV * >data

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['SVID'] = sb0.SVID
    block_dict['CRCPassed'] = sb0.CRCPassed
    block_dict['ViterbiCount'] = sb0.ViterbiCount
    block_dict['Source'] = sb0.Source
    block_dict['FreqNr'] = sb0.FreqNr
    block_dict['RxChannel'] = sb0.RxChannel
    block_dict['NAVBits'] = (< c1*>sb0.NAVBits)[0:32]

    return block_dict


BLOCKPARSERS['GALRawINAV'] = GALRawINAV_toDict


def GALRawCNAV_toDict(c1 * data):
    cdef GALRawCNAV * sb0
    sb0 = <GALRawCNAV * >data

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['SVID'] = sb0.SVID
    block_dict['CRCPassed'] = sb0.CRCPassed
    block_dict['ViterbiCount'] = sb0.ViterbiCount
    block_dict['Source'] = sb0.Source
    block_dict['FreqNr'] = sb0.FreqNr
    block_dict['RxChannel'] = sb0.RxChannel
    block_dict['NAVBits'] = (< c1*>sb0.NAVBits)[0:64]

    return block_dict


BLOCKPARSERS['GALRawCNAV'] = GALRawCNAV_toDict


def GEORawL1_toDict(c1 * data):
    cdef GEORawL1 * sb0
    sb0 = <GEORawL1 * >data

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['SVID'] = sb0.SVID
    block_dict['CRCPassed'] = sb0.CRCPassed
    block_dict['ViterbiCount'] = sb0.ViterbiCount
    block_dict['Source'] = sb0.Source
    block_dict['FreqNr'] = sb0.FreqNr
    block_dict['RxChannel'] = sb0.RxChannel
    block_dict['NAVBits'] = (< c1*>sb0.NAVBits)[0:32]

    return block_dict


BLOCKPARSERS['GEORawL1'] = GEORawL1_toDict


def GEORawL5_toDict(c1 * data):
    cdef GEORawL5 * sb0
    sb0 = <GEORawL5 * >data

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['SVID'] = sb0.SVID
    block_dict['CRCPassed'] = sb0.CRCPassed
    block_dict['ViterbiCount'] = sb0.ViterbiCount
    block_dict['Source'] = sb0.Source
    block_dict['FreqNr'] = sb0.FreqNr
    block_dict['RxChannel'] = sb0.RxChannel
    block_dict['NAVBits'] = (< c1*>sb0.NAVBits)[0:32]

    return block_dict


BLOCKPARSERS['GEORawL1'] = GEORawL5_toDict


def BDSRaw_toDict(c1 * data):
    cdef BDSRaw * sb0
    sb0 = <BDSRaw * >data

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['SVID'] = sb0.SVID
    block_dict['CRCPassed'] = sb0.CRCPassed
    block_dict['ViterbiCnt'] = sb0.ViterbiCnt
    block_dict['Source'] = sb0.Source
    block_dict['RxChannel'] = sb0.RxChannel
    block_dict['NAVBits'] = (< c1*>sb0.NAVBits)[0:40]

    return block_dict


BLOCKPARSERS['BDSRaw'] = BDSRaw_toDict


def BDSRawB1C_toDict(c1 * data):
    cdef BDSRawB1C * sb0
    sb0 = <BDSRawB1C * >data

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['SVID'] = sb0.SVID
    block_dict['CRCSF2'] = sb0.CRCSF2
    block_dict['CRCSF3'] = sb0.CRCSF3
    block_dict['Source'] = sb0.Source
    block_dict['RxChannel'] = sb0.RxChannel
    block_dict['NAVBits'] = (< c1*>sb0.NAVBits)[0:228]

    return block_dict


BLOCKPARSERS['BDSRawB1C'] = BDSRawB1C_toDict


def BDSRawB2a_toDict(c1 * data):
    cdef BDSRawB2a * sb0
    sb0 = <BDSRawB2a * >data

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['SVID'] = sb0.SVID
    block_dict['CRCPassed'] = sb0.CRCPassed
    block_dict['ViterbiCnt'] = sb0.ViterbiCnt
    block_dict['Source'] = sb0.Source
    block_dict['RxChannel'] = sb0.RxChannel
    block_dict['NAVBits'] = (< c1*>sb0.NAVBits)[0:72]

    return block_dict


BLOCKPARSERS['BDSRawB2a'] = BDSRawB2a_toDict


def BDSRawB2b_toDict(c1 * data):
    cdef BDSRawB2b * sb0
    sb0 = <BDSRawB2b * >data

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['SVID'] = sb0.SVID
    block_dict['CRCPassed'] = sb0.CRCPassed
    block_dict['Source'] = sb0.Source
    block_dict['RxChannel'] = sb0.RxChannel
    block_dict['NAVBits'] = (< c1*>sb0.NAVBits)[0:124]

    return block_dict


BLOCKPARSERS['BDSRawB2b'] = BDSRawB2b_toDict


def QZSRawL1CA_toDict(c1 * data):
    cdef QZSRawL1CA * sb0
    sb0 = <QZSRawL1CA * >data

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['SVID'] = sb0.SVID
    block_dict['CRCPassed'] = sb0.CRCPassed
    block_dict['Source'] = sb0.Source
    block_dict['RxChannel'] = sb0.RxChannel
    block_dict['NAVBits'] = (< c1*>sb0.NAVBits)[0:40]

    return block_dict


BLOCKPARSERS['QZSRawL1CA'] = QZSRawL1CA_toDict


def QZSRawL2C_toDict(c1 * data):
    cdef QZSRawL2C * sb0
    sb0 = <QZSRawL2C * >data

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['SVID'] = sb0.SVID
    block_dict['CRCPassed'] = sb0.CRCPassed
    block_dict['ViterbiCount'] = sb0.ViterbiCount
    block_dict['Source'] = sb0.Source
    block_dict['RxChannel'] = sb0.RxChannel
    block_dict['NAVBits'] = (< c1*>sb0.NAVBits)[0:40]

    return block_dict


BLOCKPARSERS['QZSRawL2C'] = QZSRawL2C_toDict


def QZSRawL5_toDict(c1 * data):
    cdef QZSRawL5 * sb0
    sb0 = <QZSRawL5 * >data

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['SVID'] = sb0.SVID
    block_dict['CRCPassed'] = sb0.CRCPassed
    block_dict['ViterbiCount'] = sb0.ViterbiCount
    block_dict['Source'] = sb0.Source
    block_dict['RxChannel'] = sb0.RxChannel
    block_dict['NAVBits'] = (< c1*>sb0.NAVBits)[0:40]

    return block_dict


BLOCKPARSERS['QZSRawL5'] = QZSRawL5_toDict


def NAVICRaw_toDict(c1 * data):
    cdef NAVICRaw * sb0
    sb0 = <NAVICRaw * >data

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['SVID'] = sb0.SVID
    block_dict['CRCPassed'] = sb0.CRCPassed
    block_dict['ViterbiCount'] = sb0.ViterbiCount
    block_dict['Source'] = sb0.Source
    block_dict['RxChannel'] = sb0.RxChannel
    block_dict['NAVBits'] = (< c1*>sb0.NAVBits)[0:40]

    return block_dict


BLOCKPARSERS['NAVICRaw'] = NAVICRaw_toDict


def GPSNav_toDict(c1 * data):
    cdef GPSNav * sb0
    sb0 = <GPSNav * >data

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['PRN'] = sb0.PRN
    block_dict['WN'] = sb0.WN
    block_dict['CAorPonL2'] = sb0.CAorPonL2
    block_dict['URA'] = sb0.URA
    block_dict['health'] = sb0.health
    block_dict['L2DataFlag'] = sb0.L2DataFlag
    block_dict['IODC'] = sb0.IODC
    block_dict['IODE2'] = sb0.IODE2
    block_dict['IODE3'] = sb0.IODE3
    block_dict['FitIntFlg'] = sb0.FitIntFlg
    block_dict['T_gd'] = sb0.T_gd
    block_dict['T_oc'] = sb0.T_oc
    block_dict['A_f2'] = sb0.A_f2
    block_dict['A_f1'] = sb0.A_f1
    block_dict['A_f0'] = sb0.A_f0
    block_dict['C_rs'] = sb0.C_rs
    block_dict['DELTA_N'] = sb0.DELTA_N
    block_dict['M_0'] = sb0.M_0
    block_dict['C_uc'] = sb0.C_uc
    block_dict['E'] = sb0.E
    block_dict['C_us'] = sb0.C_us
    block_dict['SQRT_A'] = sb0.SQRT_A
    block_dict['T_oe'] = sb0.T_oe
    block_dict['C_ic'] = sb0.C_ic
    block_dict['OMEGA_0'] = sb0.OMEGA_0
    block_dict['C_is'] = sb0.C_is
    block_dict['I_0'] = sb0.I_0
    block_dict['C_rc'] = sb0.C_rc
    block_dict['omega'] = sb0.omega
    block_dict['OMEGADOT'] = sb0.OMEGADOT
    block_dict['IDOT'] = sb0.IDOT
    block_dict['WNt_oc'] = sb0.WNt_oc
    block_dict['WNt_oe'] = sb0.WNt_oe

    return block_dict


BLOCKPARSERS['GPSNav'] = GPSNav_toDict


def GPSAlm_toDict(c1 * data):
    cdef GPSAlm * sb0
    sb0 = <GPSAlm * >data

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['PRN'] = sb0.PRN
    block_dict['E'] = sb0.E
    block_dict['t_oa'] = sb0.t_oa
    block_dict['Delta_i'] = sb0.Delta_i
    block_dict['OMEGADOT'] = sb0.OMEGADOT
    block_dict['SQRT_A'] = sb0.SQRT_A
    block_dict['OMEGA_0'] = sb0.OMEGA_0
    block_dict['Omega'] = sb0.Omega
    block_dict['M_0'] = sb0.M_0
    block_dict['a_f1'] = sb0.a_f1
    block_dict['a_f0'] = sb0.a_f0
    block_dict['WN_a'] = sb0.WN_a
    block_dict['config'] = sb0.config
    block_dict['health8'] = sb0.health8
    block_dict['health6'] = sb0.health6

    return block_dict


BLOCKPARSERS['GPSAlm'] = GPSAlm_toDict


def GPSIon_toDict(c1 * data):
    cdef GPSIon * sb0
    sb0 = <GPSIon * >data

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['PRN'] = sb0.PRN
    block_dict['alpha_0'] = sb0.alpha_0
    block_dict['alpha_1'] = sb0.alpha_1
    block_dict['alpha_2'] = sb0.alpha_2
    block_dict['alpha_3'] = sb0.alpha_3
    block_dict['beta_0'] = sb0.beta_0
    block_dict['beta_1'] = sb0.beta_1
    block_dict['beta_2'] = sb0.beta_2
    block_dict['beta_3'] = sb0.beta_3

    return block_dict


BLOCKPARSERS['GPSIon'] = GPSIon_toDict


def GPSUtc_toDict(c1 * data):
    cdef GPSUtc * sb0
    sb0 = <GPSUtc * >data

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['PRN'] = sb0.PRN
    block_dict['A_1'] = sb0.A_1
    block_dict['A_0'] = sb0.A_0
    block_dict['t_ot'] = sb0.t_ot
    block_dict['WN_t'] = sb0.WN_t
    block_dict['DEL_t_LS'] = sb0.DEL_t_LS
    block_dict['WN_LSF'] = sb0.WN_LSF
    block_dict['DN'] = sb0.DN
    block_dict['DEL_t_LSF'] = sb0.DEL_t_LSF

    return block_dict


BLOCKPARSERS['GPSUtc'] = GPSUtc_toDict

def GPSCNav_toDict(c1 * data):
    cdef GPSCNav * sb0
    sb0 = <GPSCNav * >data

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['PRN'] = sb0.PRN
    block_dict['Flags'] = sb0.Flags
    block_dict['WN'] = sb0.WN
    block_dict['health'] = sb0.health
    block_dict['URA_ED'] = sb0.URA_ED
    block_dict['t_op'] = sb0.t_op
    block_dict['t_oe'] = sb0.t_oe
    block_dict['A'] = sb0.A
    block_dict['A_DOT'] = sb0.A_DOT
    block_dict['DELTA_N'] = sb0.DELTA_N
    block_dict['DELTA_N_DOT'] = sb0.DELTA_N_DOT
    block_dict['M_0'] = sb0.M_0
    block_dict['e'] = sb0.e
    block_dict['omega'] = sb0.omega
    block_dict['OMEGA_0'] = sb0.OMEGA_0
    block_dict['OMEGADOT'] = sb0.OMEGADOT
    block_dict['i_0'] = sb0.i_0
    block_dict['IDOT'] = sb0.IDOT
    block_dict['C_is'] = sb0.C_is
    block_dict['C_ic'] = sb0.C_ic
    block_dict['C_rs'] = sb0.C_rs
    block_dict['C_rc'] = sb0.C_rc
    block_dict['C_us'] = sb0.C_us
    block_dict['C_uc'] = sb0.C_uc
    block_dict['t_oc'] = sb0.t_oc
    block_dict['URA_NED0'] = sb0.URA_NED0
    block_dict['URA_NED1'] = sb0.URA_NED1
    block_dict['URA_NED2'] = sb0.URA_NED2
    block_dict['WN_op'] = sb0.WN_op
    block_dict['a_f2'] = sb0.a_f2
    block_dict['a_f1'] = sb0.a_f1
    block_dict['a_f0'] = sb0.a_f0
    block_dict['T_gd'] = sb0.T_gd
    block_dict['ISC_L1CA'] = sb0.ISC_L1CA
    block_dict['ISC_L2C'] = sb0.ISC_L2C
    block_dict['ISC_L5I5'] = sb0.ISC_L5I5
    block_dict['ISC_L5Q5'] = sb0.ISC_L5Q5

    return block_dict


BLOCKPARSERS['GPSCNav'] = GPSCNav_toDict


def GLONav_toDict(c1 * data):
    cdef GLONav * sb0
    sb0 = <GLONav * >data

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['SVID'] = sb0.SVID
    block_dict['FreqNr'] = sb0.FreqNr
    block_dict['X'] = sb0.X
    block_dict['Y'] = sb0.Y
    block_dict['Z'] = sb0.Z
    block_dict['Dx'] = sb0.Dx
    block_dict['Dy'] = sb0.Dy
    block_dict['Dz'] = sb0.Dz
    block_dict['Ddx'] = sb0.Ddx
    block_dict['Ddy'] = sb0.Ddy
    block_dict['Ddz'] = sb0.Ddz
    block_dict['gamma'] = sb0.gamma
    block_dict['tau'] = sb0.tau
    block_dict['dtau'] = sb0.dtau
    block_dict['t_oe'] = sb0.t_oe
    block_dict['WN_toe'] = sb0.WN_toe
    block_dict['P1'] = sb0.P1
    block_dict['P2'] = sb0.P2
    block_dict['E'] = sb0.E
    block_dict['B'] = sb0.B
    block_dict['tb'] = sb0.tb
    block_dict['M'] = sb0.M
    block_dict['P'] = sb0.P
    block_dict['l'] = sb0.l
    block_dict['P4'] = sb0.P4
    block_dict['N_T'] = sb0.N_T
    block_dict['F_T'] = sb0.F_T
    block_dict['C'] = sb0.C

    return block_dict


BLOCKPARSERS['GLONav'] = GLONav_toDict


def GLOAlm_toDict(c1 * data):
    cdef GLOAlm * sb0
    sb0 = <GLOAlm * >data

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['SVID'] = sb0.SVID
    block_dict['FreqNr'] = sb0.FreqNr
    block_dict['epsilon'] = sb0.epsilon
    block_dict['t_oa'] = sb0.t_oa
    block_dict['Delta_i'] = sb0.Delta_i
    block_dict['Lambda'] = sb0.Lambda
    block_dict['t_ln'] = sb0.t_ln
    block_dict['omega'] = sb0.omega
    block_dict['Delta_T'] = sb0.Delta_T
    block_dict['dDelta_t'] = sb0.dDelta_t
    block_dict['tau'] = sb0.tau
    block_dict['WN_a'] = sb0.WN_a
    block_dict['C'] = sb0.C
    block_dict['N'] = sb0.N
    block_dict['M'] = sb0.M
    block_dict['N_4'] = sb0.N_4

    return block_dict


BLOCKPARSERS['GLOAlm'] = GLOAlm_toDict


def GLOTime_toDict(c1 * data):
    cdef GLOTime * sb0
    sb0 = <GLOTime * >data

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['SVID'] = sb0.SVID
    block_dict['FreqNr'] = sb0.FreqNr
    block_dict['N_4'] = sb0.N_4
    block_dict['KP'] = sb0.KP
    block_dict['N'] = sb0.N
    block_dict['tau_GPS'] = sb0.tau_GPS
    block_dict['tau_c'] = sb0.tau_c
    block_dict['B1'] = sb0.B1
    block_dict['B2'] = sb0.B2

    return block_dict


BLOCKPARSERS['GLOTime'] = GLOTime_toDict


def GALNav_toDict(c1 * data):
    cdef GALNav * sb0
    sb0 = <GALNav * >data

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['SVID'] = sb0.SVID
    block_dict['Source'] = sb0.Source
    block_dict['SQRT_A'] = sb0.SQRT_A
    block_dict['M_0'] = sb0.M_0
    block_dict['E'] = sb0.E
    block_dict['i_0'] = sb0.i_0
    block_dict['Omega'] = sb0.Omega
    block_dict['OMEGA_0'] = sb0.OMEGA_0
    block_dict['OMEGADOT'] = sb0.OMEGADOT
    block_dict['IDOT'] = sb0.IDOT
    block_dict['DELTA_N'] = sb0.DELTA_N
    block_dict['C_uc'] = sb0.C_uc
    block_dict['C_us'] = sb0.C_us
    block_dict['C_rc'] = sb0.C_rc
    block_dict['C_rs'] = sb0.C_rs
    block_dict['C_ic'] = sb0.C_ic
    block_dict['C_is'] = sb0.C_is
    block_dict['t_oe'] = sb0.t_oe
    block_dict['t_oc'] = sb0.t_oc
    block_dict['a_f2'] = sb0.a_f2
    block_dict['a_f1'] = sb0.a_f1
    block_dict['a_f0'] = sb0.a_f0
    block_dict['WNt_oe'] = sb0.WNt_oe
    block_dict['WNt_oc'] = sb0.WNt_oc
    block_dict['IODnav'] = sb0.IODnav
    block_dict['Health_OSSOL'] = sb0.Health_OSSOL
    block_dict['Health_PRS'] = sb0.Health_PRS
    block_dict['SISA_L1AE6A'] = sb0.SISA_L1AE6A
    block_dict['SISA_L1E5a'] = sb0.SISA_L1E5a
    block_dict['SISA_L1E5b'] = sb0.SISA_L1E5b
    block_dict['BGD_L1E5a'] = sb0.BGD_L1E5a
    block_dict['BGD_L1E5b'] = sb0.BGD_L1E5b
    block_dict['BGD_L1AE6A'] = sb0.BGD_L1AE6A
    block_dict['CNAVenc'] = sb0.CNAVenc

    return block_dict


BLOCKPARSERS['GALNav'] = GALNav_toDict


def GALAlm_toDict(c1 * data):
    cdef GALAlm * sb0
    sb0 = <GALAlm * >data

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['SVID'] = sb0.SVID
    block_dict['Source'] = sb0.Source
    block_dict['e'] = sb0.e
    block_dict['t_oa'] = sb0.t_oa
    block_dict['Delta_i'] = sb0.Delta_i
    block_dict['OMEGADOT'] = sb0.OMEGADOT
    block_dict['SQRT_A'] = sb0.SQRT_A
    block_dict['OMEGA_0'] = sb0.OMEGA_0
    block_dict['Omega'] = sb0.Omega
    block_dict['M_0'] = sb0.M_0
    block_dict['a_f1'] = sb0.a_f1
    block_dict['a_f0'] = sb0.a_f0
    block_dict['WN_a'] = sb0.WN_a
    block_dict['SVID_A'] = sb0.SVID_A
    block_dict['health'] = sb0.health
    block_dict['IODa'] = sb0.IODa

    return block_dict


BLOCKPARSERS['GALAlm'] = GALAlm_toDict


def GALIon_toDict(c1 * data):
    cdef GALIon * sb0
    sb0 = <GALIon * >data

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['SVID'] = sb0.SVID
    block_dict['Source'] = sb0.Source
    block_dict['a_i0'] = sb0.a_i0
    block_dict['a_i1'] = sb0.a_i1
    block_dict['a_i2'] = sb0.a_i2
    block_dict['StormFlags'] = sb0.StormFlags

    return block_dict


BLOCKPARSERS['GALIon'] = GALIon_toDict


def GALUtc_toDict(c1 * data):
    cdef GALUtc * sb0
    sb0 = <GALUtc * >data

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['SVID'] = sb0.SVID
    block_dict['Source'] = sb0.Source
    block_dict['A_1'] = sb0.A_1
    block_dict['A_0'] = sb0.A_0
    block_dict['t_ot'] = sb0.t_ot
    block_dict['WN_ot'] = sb0.WN_ot
    block_dict['DEL_t_LS'] = sb0.DEL_t_LS
    block_dict['WN_LSF'] = sb0.WN_LSF
    block_dict['DN'] = sb0.DN
    block_dict['DEL_t_LSF'] = sb0.DEL_t_LSF

    return block_dict


BLOCKPARSERS['GALUtc'] = GALUtc_toDict


def GALGstGps_toDict(c1 * data):
    cdef GALGstGps * sb0
    sb0 = <GALGstGps * >data

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['SVID'] = sb0.SVID
    block_dict['Source'] = sb0.Source
    block_dict['A_1G'] = sb0.A_1G
    block_dict['A_0G'] = sb0.A_0G
    block_dict['t_oG'] = sb0.t_oG
    block_dict['WN_oG'] = sb0.WN_oG

    return block_dict


BLOCKPARSERS['GALGstGps'] = GALGstGps_toDict


def GALSARRLM_toDict(c1 * data):
    cdef GALSARRLM * sb0
    sb0 = <GALSARRLM * >data

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['SVID'] = sb0.SVID
    block_dict['Source'] = sb0.Source
    block_dict['RLMLength'] = sb0.RLMLength

    if sb0.RLMLength == 80:
        block_dict['RLMBits'] = (< c1*>&sb0.RLMBits)[0:12]
    else:
        block_dict['RLMBits'] = (< c1*>&sb0.RLMBits)[0:20]

    return block_dict


BLOCKPARSERS['GALSARRLM'] = GALSARRLM_toDict


def BDSNav_toDict(c1 * data):
    cdef BDSNav * sb0
    sb0 = <BDSNav * >data

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['PRN'] = sb0.PRN
    block_dict['WN'] = sb0.WN
    block_dict['URA'] = sb0.URA
    block_dict['SatH1'] = sb0.SatH1
    block_dict['IODC'] = sb0.IODC
    block_dict['IODE'] = sb0.IODE
    block_dict['T_GD1'] = sb0.T_GD1
    block_dict['T_GD2'] = sb0.T_GD2
    block_dict['t_oc'] = sb0.t_oc
    block_dict['a_f2'] = sb0.a_f2
    block_dict['a_f1'] = sb0.a_f1
    block_dict['a_f0'] = sb0.a_f0
    block_dict['C_rs'] = sb0.C_rs
    block_dict['DEL_N'] = sb0.DEL_N
    block_dict['M_0'] = sb0.M_0
    block_dict['C_uc'] = sb0.C_uc
    block_dict['e'] = sb0.e
    block_dict['C_us'] = sb0.C_us
    block_dict['SQRT_A'] = sb0.SQRT_A
    block_dict['t_oe'] = sb0.t_oe
    block_dict['C_ic'] = sb0.C_ic
    block_dict['OMEGA_0'] = sb0.OMEGA_0
    block_dict['C_is'] = sb0.C_is
    block_dict['i_0'] = sb0.i_0
    block_dict['C_rc'] = sb0.C_rc
    block_dict['omega'] = sb0.omega
    block_dict['OMEGADOT'] = sb0.OMEGADOT
    block_dict['IDOT'] = sb0.IDOT
    block_dict['WNt_oc'] = sb0.WNt_oc
    block_dict['WNt_oe'] = sb0.WNt_oe

    return block_dict


BLOCKPARSERS['BDSNav'] = BDSNav_toDict


def BDSAlm_toDict(c1 * data):
    cdef BDSAlm * sb0
    sb0 = <BDSAlm * >data

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['PRN'] = sb0.PRN
    block_dict['WN_a'] = sb0.WN_a
    block_dict['t_oa'] = sb0.t_oa
    block_dict['SQRT_A'] = sb0.SQRT_A
    block_dict['e'] = sb0.e
    block_dict['omega'] = sb0.omega
    block_dict['M_0'] = sb0.M_0
    block_dict['OMEGA_0'] = sb0.OMEGA_0
    block_dict['OMEGADOT'] = sb0.OMEGADOT
    block_dict['delta_i'] = sb0.delta_i
    block_dict['a_f0'] = sb0.a_f0
    block_dict['a_f1'] = sb0.a_f1
    block_dict['Health'] = sb0.Health
    return block_dict


BLOCKPARSERS['BDSAlm'] = BDSAlm_toDict


def BDSIon_toDict(c1 * data):
    cdef BDSIon * sb0
    sb0 = <BDSIon * >data

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['PRN'] = sb0.PRN
    block_dict['alpha_0'] = sb0.alpha_0
    block_dict['alpha_1'] = sb0.alpha_1
    block_dict['alpha_2'] = sb0.alpha_2
    block_dict['alpha_3'] = sb0.alpha_3
    block_dict['beta_0'] = sb0.beta_0
    block_dict['beta_1'] = sb0.beta_1
    block_dict['beta_2'] = sb0.beta_2
    block_dict['beta_3'] = sb0.beta_3

    return block_dict


BLOCKPARSERS['BDSIon'] = BDSIon_toDict


def BDSUtc_toDict(c1 * data):
    cdef BDSUtc * sb0
    sb0 = <BDSUtc * >data

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['PRN'] = sb0.PRN
    block_dict['A_1'] = sb0.A_1
    block_dict['A_0'] = sb0.A_0
    block_dict['DEL_t_LS'] = sb0.DEL_t_LS
    block_dict['WN_LSF'] = sb0.WN_LSF
    block_dict['DN'] = sb0.DN
    block_dict['DEL_t_LSF'] = sb0.DEL_t_LSF

    return block_dict


BLOCKPARSERS['BDSUtc'] = BDSUtc_toDict


def QZSNav_toDict(c1 * data):
    cdef QZSNav * sb0
    sb0 = <QZSNav * >data

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['PRN'] = sb0.PRN
    block_dict['WN'] = sb0.WN
    block_dict['CAorPonL2'] = sb0.CAorPonL2
    block_dict['URA'] = sb0.URA
    block_dict['health'] = sb0.health
    block_dict['L2DataFlag'] = sb0.L2DataFlag
    block_dict['IODC'] = sb0.IODC
    block_dict['IODE2'] = sb0.IODE2
    block_dict['IODE3'] = sb0.IODE3
    block_dict['FitIntFlg'] = sb0.FitIntFlg
    block_dict['T_gd'] = sb0.T_gd
    block_dict['t_oc'] = sb0.t_oc
    block_dict['a_f2'] = sb0.a_f2
    block_dict['a_f1'] = sb0.a_f1
    block_dict['a_f0'] = sb0.a_f0
    block_dict['C_rs'] = sb0.C_rs
    block_dict['DEL_N'] = sb0.DEL_N
    block_dict['M_0'] = sb0.M_0
    block_dict['C_uc'] = sb0.C_uc
    block_dict['e'] = sb0.e
    block_dict['C_us'] = sb0.C_us
    block_dict['SQRT_A'] = sb0.SQRT_A
    block_dict['t_oe'] = sb0.t_oe
    block_dict['C_ic'] = sb0.C_ic
    block_dict['OMEGA_0'] = sb0.OMEGA_0
    block_dict['C_is'] = sb0.C_is
    block_dict['i_0'] = sb0.i_0
    block_dict['C_rc'] = sb0.C_rc
    block_dict['omega'] = sb0.omega
    block_dict['OMEGADOT'] = sb0.OMEGADOT
    block_dict['IDOT'] = sb0.IDOT
    block_dict['WNt_oc'] = sb0.WNt_oc
    block_dict['WNt_oe'] = sb0.WNt_oe

    return block_dict


BLOCKPARSERS['QZSNav'] = QZSNav_toDict


def QZSAlm_toDict(c1 * data):
    cdef QZSAlm * sb0
    sb0 = <QZSAlm * >data

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['PRN'] = sb0.PRN
    block_dict['e'] = sb0.e
    block_dict['t_oa'] = sb0.t_oa
    block_dict['delta_i'] = sb0.delta_i
    block_dict['OMEGADOT'] = sb0.OMEGADOT
    block_dict['SQRT_A'] = sb0.SQRT_A
    block_dict['OMEGA_0'] = sb0.OMEGA_0
    block_dict['omega'] = sb0.omega
    block_dict['M_0'] = sb0.M_0
    block_dict['a_f1'] = sb0.a_f1
    block_dict['a_f0'] = sb0.a_f0
    block_dict['WN_a'] = sb0.WN_a
    block_dict['health8'] = sb0.health8
    block_dict['health6'] = sb0.health6

    return block_dict


BLOCKPARSERS['QZSAlm'] = QZSAlm_toDict


def GEOMT00_toDict(c1 * data):
    cdef GEOMT00 * sb0
    sb0 = <GEOMT00 * >data

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['PRN'] = sb0.PRN

    return block_dict


BLOCKPARSERS['GEOMT00'] = GEOMT00_toDict


def GEOPRNMask_toDict(c1 * data):
    cdef GEOPRNMask * sb0
    sb0 = <GEOPRNMask * >data

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['PRN'] = sb0.PRN
    block_dict['IODP'] = sb0.IODP
    block_dict['NbrPRNs'] = sb0.NbrPRNs

    block_dict['PRNMask'] = (< c1*>&sb0.PRNMask)[0:sb0.NbrPRNs]

    return block_dict


BLOCKPARSERS['GEOPRNMask'] = GEOPRNMask_toDict


def GEOFastCorr_toDict(c1 * data):
    cdef GEOFastCorr * sb0
    cdef GEOFastCorr_FastCorr * sb1
    cdef size_t i

    cdef GEOFastCorr_FastCorr ** sb1s

    sb0 = <GEOFastCorr * >data
    i = sizeof(GEOFastCorr)

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['PRN'] = sb0.PRN
    block_dict['MT'] = sb0.MT
    block_dict['IODP'] = sb0.IODP
    block_dict['IODF'] = sb0.IODF
    block_dict['N'] = sb0.N
    block_dict['SBLength'] = sb0.SBLength

    sb1s = <GEOFastCorr_FastCorr ** >malloc(sb0.N * sizeof(GEOFastCorr_FastCorr * ) )

    sb1_list = [None] * sb0.N
    block_dict['FastCorr'] = sb1_list

    for n in xrange(sb0.N):
        sb1 = sb1s[n] = <GEOFastCorr_FastCorr*>(data + i)
        i += sb0.SBLength
        sb1_dict = dict()
        sb1_list[n] = sb1_dict
        sb1_dict['PRNMaskNo'] = sb1.PRNMaskNo
        sb1_dict['UDREI'] = sb1.UDREI
        sb1_dict['PRC'] = sb1.PRC

    free(sb1s)
    return block_dict


BLOCKPARSERS['GEOFastCorr'] = GEOFastCorr_toDict


def GEOIntegrity_toDict(c1 * data):
    cdef GEOIntegrity * sb0
    sb0 = <GEOIntegrity * >data

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['PRN'] = sb0.PRN
    block_dict['IODF'] = (< c1*>sb0.IODF)[0:4]
    block_dict['UDREI'] = (< c1*>sb0.UDREI)[0:51]

    return block_dict


BLOCKPARSERS['GEOIntegrity'] = GEOIntegrity_toDict


def GEOFastCorrDegr_toDict(c1 * data):
    cdef GEOFastCorrDegr * sb0
    sb0 = <GEOFastCorrDegr * >data

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['PRN'] = sb0.PRN
    block_dict['IODP'] = sb0.IODP
    block_dict['t_lat'] = sb0.t_lat
    block_dict['AI'] = (< c1*>sb0.AI)[0:51]

    return block_dict


BLOCKPARSERS['GEOFastCorrDegr'] = GEOFastCorrDegr_toDict


def GEONav_toDict(c1 * data):
    cdef GEONav * sb0
    sb0 = <GEONav * >data

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['PRN'] = sb0.PRN
    block_dict['IODN'] = sb0.IODN
    block_dict['URA'] = sb0.URA
    block_dict['t0'] = sb0.t0
    block_dict['Xg'] = sb0.Xg
    block_dict['Yg'] = sb0.Yg
    block_dict['Zg'] = sb0.Zg
    block_dict['Xgd'] = sb0.Xgd
    block_dict['Ygd'] = sb0.Ygd
    block_dict['Zgd'] = sb0.Zgd
    block_dict['Xgdd'] = sb0.Xgdd
    block_dict['Ygdd'] = sb0.Ygdd
    block_dict['Zgdd'] = sb0.Zgdd
    block_dict['AGf0'] = sb0.AGf0
    block_dict['AGf1'] = sb0.AGf1

    return block_dict


BLOCKPARSERS['GEONav'] = GEONav_toDict


def GEODegrFactors_toDict(c1 * data):
    cdef GEODegrFactors * sb0
    sb0 = <GEODegrFactors * >data

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['PRN'] = sb0.PRN
    block_dict['Brrc'] = sb0.Brrc
    block_dict['Cltc_lsb'] = sb0.Cltc_lsb
    block_dict['Cltc_v1'] = sb0.Cltc_v1
    block_dict['Iltc_v1'] = sb0.Iltc_v1
    block_dict['Cltc_v0'] = sb0.Cltc_v0
    block_dict['Iltc_v0'] = sb0.Iltc_v0
    block_dict['Cgeo_lsb'] = sb0.Cgeo_lsb
    block_dict['Cgeo_v'] = sb0.Cgeo_v
    block_dict['Igeo'] = sb0.Igeo
    block_dict['Cer'] = sb0.Cer
    block_dict['Ciono_step'] = sb0.Ciono_step
    block_dict['Iiono'] = sb0.Iiono
    block_dict['Ciono_ramp'] = sb0.Ciono_ramp
    block_dict['RSSudre'] = sb0.RSSudre
    block_dict['RSSiono'] = sb0.RSSiono
    block_dict['Ccovariance'] = sb0.Ccovariance

    return block_dict


BLOCKPARSERS['GEODegrFactors'] = GEODegrFactors_toDict


def GEONetworkTime_toDict(c1 * data):
    cdef GEONetworkTime * sb0
    sb0 = <GEONetworkTime * >data

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['PRN'] = sb0.PRN
    block_dict['A1'] = sb0.A1
    block_dict['A0'] = sb0.A0
    block_dict['t_ot'] = sb0.t_ot
    block_dict['WNt'] = sb0.WNt
    block_dict['DEL_t_1S'] = sb0.DEL_t_1S
    block_dict['WN_LSF'] = sb0.WN_LSF
    block_dict['DN'] = sb0.DN
    block_dict['DEL_t_LSF'] = sb0.DEL_t_LSF
    block_dict['UTC_std'] = sb0.UTC_std
    block_dict['GPS_WN'] = sb0.GPS_WN
    block_dict['GPS_TOW'] = sb0.GPS_TOW
    block_dict['GLONASSind'] = sb0.GLONASSind

    return block_dict


BLOCKPARSERS['GEONetworkTime'] = GEONetworkTime_toDict


def GEOAlm_toDict(c1 * data):
    cdef GEOAlm * sb0
    sb0 = <GEOAlm * >data

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['PRN'] = sb0.PRN
    block_dict['DataID'] = sb0.DataID
    block_dict['Health'] = sb0.Health
    block_dict['t_0a'] = sb0.t_0a
    block_dict['Xg'] = sb0.Xg
    block_dict['Yg'] = sb0.Yg
    block_dict['Zg'] = sb0.Zg
    block_dict['Xgd'] = sb0.Xgd
    block_dict['Ygd'] = sb0.Ygd
    block_dict['Zgd'] = sb0.Zgd

    return block_dict


BLOCKPARSERS['GEOAlm'] = GEOAlm_toDict


def GEOIGPMask_toDict(c1 * data):
    cdef GEOIGPMask * sb0
    sb0 = <GEOIGPMask * >data

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['PRN'] = sb0.PRN
    block_dict['NbrBands'] = sb0.NbrBands
    block_dict['BandNbr'] = sb0.BandNbr
    block_dict['IODI'] = sb0.IODI
    block_dict['NbrIGPs'] = sb0.NbrIGPs

    block_dict['IGPMask'] = (< c1*>&sb0.IGPMask)[0:sb0.NbrIGPs]

    return block_dict


BLOCKPARSERS['GEOIGPMask'] = GEOIGPMask_toDict


def GEOLongTermCorr_toDict(c1 * data):
    cdef GEOLongTermCorr * sb0
    cdef GEOLongTermCorr_LTCorr * sb1
    cdef size_t i

    cdef GEOLongTermCorr_LTCorr ** sb1s

    sb0 = <GEOLongTermCorr * >data
    i = sizeof(GEOLongTermCorr)

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['PRN'] = sb0.PRN
    block_dict['N'] = sb0.N
    block_dict['SBLength'] = sb0.SBLength

    sb1s = <GEOLongTermCorr_LTCorr ** >malloc(sb0.N * sizeof(GEOLongTermCorr_LTCorr * ) )

    sb1_list = [None] * sb0.N
    block_dict['LTCorr'] = sb1_list

    for n in xrange(sb0.N):
        sb1 = sb1s[n] = <GEOLongTermCorr_LTCorr*>(data + i)
        i += sb0.SBLength
        sb1_dict = dict()
        sb1_list[n] = sb1_dict
        sb1_dict['VelocityCode'] = sb1.VelocityCode
        sb1_dict['PRNMaskNo'] = sb1.PRNMaskNo
        sb1_dict['IODP'] = sb1.IODP
        sb1_dict['IODE'] = sb1.IODE
        sb1_dict['dx'] = sb1.dx
        sb1_dict['dy'] = sb1.dy
        sb1_dict['dz'] = sb1.dz
        sb1_dict['dxRate'] = sb1.dxRate
        sb1_dict['dyRate'] = sb1.dyRate
        sb1_dict['dzRate'] = sb1.dzRate
        sb1_dict['da_f0'] = sb1.da_f0
        sb1_dict['da_f1'] = sb1.da_f1
        sb1_dict['t_oe'] = sb1.t_oe

    free(sb1s)
    return block_dict


BLOCKPARSERS['GEOLongTermCorr'] = GEOLongTermCorr_toDict


def GEOIonoDelay_toDict(c1 * data):
    cdef GEOIonoDelay * sb0
    cdef GEOIonoDelay_IDC * sb1
    cdef size_t i

    cdef GEOIonoDelay_IDC ** sb1s

    sb0 = <GEOIonoDelay * >data
    i = sizeof(GEOIonoDelay)

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['PRN'] = sb0.PRN
    block_dict['BandNbr'] = sb0.BandNbr
    block_dict['IODI'] = sb0.IODI
    block_dict['N'] = sb0.N
    block_dict['SBLength'] = sb0.SBLength

    sb1s = <GEOIonoDelay_IDC ** >malloc(sb0.N * sizeof(GEOIonoDelay_IDC * ) )

    sb1_list = [None] * sb0.N
    block_dict['IDC'] = sb1_list

    for n in xrange(sb0.N):
        sb1 = sb1s[n] = <GEOIonoDelay_IDC*>(data + i)
        i += sb0.SBLength
        sb1_dict = dict()
        sb1_list[n] = sb1_dict
        sb1_dict['IGPMaskNo'] = sb1.IGPMaskNo
        sb1_dict['GIVEI'] = sb1.GIVEI
        sb1_dict['VerticalDelay'] = sb1.VerticalDelay

    free(sb1s)
    return block_dict


BLOCKPARSERS['GEOIonoDelay'] = GEOIonoDelay_toDict


def GEOServiceLevel_toDict(c1 * data):
    cdef GEOServiceLevel * sb0
    cdef GEOServiceLevel_ServiceRegion * sb1
    cdef size_t i

    cdef GEOServiceLevel_ServiceRegion ** sb1s

    sb0 = <GEOServiceLevel * >data
    i = sizeof(GEOServiceLevel)

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['PRN'] = sb0.PRN
    block_dict['IODS'] = sb0.IODS
    block_dict['NrMessages'] = sb0.NrMessages
    block_dict['MessageNr'] = sb0.MessageNr
    block_dict['PriorityCode'] = sb0.PriorityCode
    block_dict['dUDREI_In'] = sb0.dUDREI_In
    block_dict['dUDREI_Out'] = sb0.dUDREI_Out
    block_dict['N'] = sb0.N
    block_dict['SBLength'] = sb0.SBLength

    sb1s = <GEOServiceLevel_ServiceRegion ** >malloc(sb0.N * sizeof(GEOServiceLevel_ServiceRegion * ) )

    sb1_list = [None] * sb0.N
    block_dict['ServiceRegion'] = sb1_list

    for n in xrange(sb0.N):
        sb1 = sb1s[n] = <GEOServiceLevel_ServiceRegion*>(data + i)
        i += sb0.SBLength
        sb1_dict = dict()
        sb1_list[n] = sb1_dict
        sb1_dict['Latitude1'] = sb1.Latitude1
        sb1_dict['Latitude2'] = sb1.Latitude2
        sb1_dict['Longitude1'] = sb1.Longitude1
        sb1_dict['Longitude2'] = sb1.Longitude2
        sb1_dict['RegionShape'] = sb1.RegionShape

    free(sb1s)
    return block_dict


BLOCKPARSERS['GEOServiceLevel'] = GEOServiceLevel_toDict


def GEOClockEphCovMatrix_toDict(c1 * data):
    cdef GEOClockEphCovMatrix * sb0
    cdef GEOClockEphCovMatrix_CovMatrix * sb1
    cdef size_t i

    cdef GEOClockEphCovMatrix_CovMatrix ** sb1s

    sb0 = <GEOClockEphCovMatrix * >data
    i = sizeof(GEOClockEphCovMatrix)

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['PRN'] = sb0.PRN
    block_dict['IODP'] = sb0.IODP
    block_dict['N'] = sb0.N
    block_dict['SBLength'] = sb0.SBLength

    sb1s = <GEOClockEphCovMatrix_CovMatrix ** >malloc(sb0.N * sizeof(GEOClockEphCovMatrix_CovMatrix * ) )

    sb1_list = [None] * sb0.N
    block_dict['CovMatrix'] = sb1_list

    for n in xrange(sb0.N):
        sb1 = sb1s[n] = <GEOClockEphCovMatrix_CovMatrix*>(data + i)
        i += sb0.SBLength
        sb1_dict = dict()
        sb1_list[n] = sb1_dict
        sb1_dict['PRNMaskNo'] = sb1.PRNMaskNo
        sb1_dict['ScaleExp'] = sb1.ScaleExp
        sb1_dict['E11'] = sb1.E11
        sb1_dict['E22'] = sb1.E22
        sb1_dict['E33'] = sb1.E33
        sb1_dict['E44'] = sb1.E44
        sb1_dict['E12'] = sb1.E12
        sb1_dict['E13'] = sb1.E13
        sb1_dict['E14'] = sb1.E14
        sb1_dict['E23'] = sb1.E23
        sb1_dict['E24'] = sb1.E24
        sb1_dict['E34'] = sb1.E34

    free(sb1s)
    return block_dict


BLOCKPARSERS['GEOClockEphCovMatrix'] = GEOClockEphCovMatrix_toDict


def PVTCartesian_toDict(c1 * data):
    cdef PVTCartesian * sb0
    sb0 = <PVTCartesian * >data

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['Mode'] = sb0.Mode
    block_dict['Error'] = sb0.Error
    block_dict['X'] = sb0.X
    block_dict['Y'] = sb0.Y
    block_dict['Z'] = sb0.Z
    block_dict['Undulation'] = sb0.Undulation
    block_dict['Vx'] = sb0.Vx
    block_dict['Vy'] = sb0.Vy
    block_dict['Vz'] = sb0.Vz
    block_dict['COG'] = sb0.COG
    block_dict['RxClkBias'] = sb0.RxClkBias
    block_dict['RxClkDrift'] = sb0.RxClkDrift
    block_dict['TimeSystem'] = sb0.TimeSystem
    block_dict['Datum'] = sb0.Datum
    block_dict['NrSV'] = sb0.NrSV
    block_dict['WACorrInfo'] = sb0.WACorrInfo
    block_dict['ReferenceID'] = sb0.ReferenceID
    block_dict['MeanCorrAge'] = sb0.MeanCorrAge
    block_dict['SignalInfo'] = sb0.SignalInfo
    block_dict['AlertFlag'] = sb0.AlertFlag
    block_dict['NrBases'] = sb0.NrBases
    block_dict['PPPInfo'] = sb0.PPPInfo
    block_dict['Latency'] = sb0.Latency
    block_dict['HAccuracy'] = sb0.HAccuracy
    block_dict['VAccuracy'] = sb0.VAccuracy
    block_dict['Misc'] = sb0.Misc

    return block_dict


BLOCKPARSERS['PVTCartesian'] = PVTCartesian_toDict


def PVTGeodetic_toDict(c1 * data):
    cdef PVTGeodetic * sb0
    sb0 = <PVTGeodetic * >data

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['Mode'] = sb0.Mode
    block_dict['Error'] = sb0.Error
    block_dict['Latitude'] = sb0.Latitude
    block_dict['Longitude'] = sb0.Longitude
    block_dict['Height'] = sb0.Height
    block_dict['Undulation'] = sb0.Undulation
    block_dict['Vn'] = sb0.Vn
    block_dict['Ve'] = sb0.Ve
    block_dict['Vu'] = sb0.Vu
    block_dict['COG'] = sb0.COG
    block_dict['RxClkBias'] = sb0.RxClkBias
    block_dict['RxClkDrift'] = sb0.RxClkDrift
    block_dict['TimeSystem'] = sb0.TimeSystem
    block_dict['Datum'] = sb0.Datum
    block_dict['NrSV'] = sb0.NrSV
    block_dict['WACorrInfo'] = sb0.WACorrInfo
    block_dict['ReferenceID'] = sb0.ReferenceID
    block_dict['MeanCorrAge'] = sb0.MeanCorrAge
    block_dict['SignalInfo'] = sb0.SignalInfo
    block_dict['AlertFlag'] = sb0.AlertFlag
    block_dict['NrBases'] = sb0.NrBases
    block_dict['PPPInfo'] = sb0.PPPInfo
    block_dict['Latency'] = sb0.Latency
    block_dict['HAccuracy'] = sb0.HAccuracy
    block_dict['VAccuracy'] = sb0.VAccuracy
    block_dict['Misc'] = sb0.Misc

    return block_dict


BLOCKPARSERS['PVTGeodetic'] = PVTGeodetic_toDict


def PosCovCartesian_toDict(c1 * data):
    cdef PosCovCartesian * sb0
    sb0 = <PosCovCartesian * >data

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['Mode'] = sb0.Mode
    block_dict['Error'] = sb0.Error
    block_dict['Cov_xx'] = sb0.Cov_xx
    block_dict['Cov_yy'] = sb0.Cov_yy
    block_dict['Cov_zz'] = sb0.Cov_zz
    block_dict['Cov_bb'] = sb0.Cov_bb
    block_dict['Cov_xy'] = sb0.Cov_xy
    block_dict['Cov_xz'] = sb0.Cov_xz
    block_dict['Cov_xb'] = sb0.Cov_xb
    block_dict['Cov_yz'] = sb0.Cov_yz
    block_dict['Cov_yb'] = sb0.Cov_yb
    block_dict['Cov_zb'] = sb0.Cov_zb

    return block_dict


BLOCKPARSERS['PosCovCartesian'] = PosCovCartesian_toDict


def PosCovGeodetic_toDict(c1 * data):
    cdef PosCovGeodetic * sb0
    sb0 = <PosCovGeodetic * >data

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['Mode'] = sb0.Mode
    block_dict['Error'] = sb0.Error
    block_dict['Cov_latlat'] = sb0.Cov_latlat
    block_dict['Cov_lonlon'] = sb0.Cov_lonlon
    block_dict['Cov_hgthgt'] = sb0.Cov_hgthgt
    block_dict['Cov_bb'] = sb0.Cov_bb
    block_dict['Cov_latlon'] = sb0.Cov_latlon
    block_dict['Cov_lathgt'] = sb0.Cov_lathgt
    block_dict['Cov_latb'] = sb0.Cov_latb
    block_dict['Cov_lonhgt'] = sb0.Cov_lonhgt
    block_dict['Cov_lonb'] = sb0.Cov_lonb
    block_dict['Cov_hb'] = sb0.Cov_hb

    return block_dict


BLOCKPARSERS['PosCovGeodetic'] = PosCovGeodetic_toDict


def VelCovCartesian_toDict(c1 * data):
    cdef VelCovCartesian * sb0
    sb0 = <VelCovCartesian * >data

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['Mode'] = sb0.Mode
    block_dict['Error'] = sb0.Error
    block_dict['Cov_VxVx'] = sb0.Cov_VxVx
    block_dict['Cov_VyVy'] = sb0.Cov_VyVy
    block_dict['Cov_VzVz'] = sb0.Cov_VzVz
    block_dict['Cov_DtDt'] = sb0.Cov_DtDt
    block_dict['Cov_VxVy'] = sb0.Cov_VxVy
    block_dict['Cov_VxVz'] = sb0.Cov_VxVz
    block_dict['Cov_VxDt'] = sb0.Cov_VxDt
    block_dict['Cov_VyVz'] = sb0.Cov_VyVz
    block_dict['Cov_VyDt'] = sb0.Cov_VyDt
    block_dict['Cov_VzDt'] = sb0.Cov_VzDt

    return block_dict


BLOCKPARSERS['VelCovCartesian'] = VelCovCartesian_toDict


def VelCovGeodetic_toDict(c1 * data):
    cdef VelCovGeodetic * sb0
    sb0 = <VelCovGeodetic * >data

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['Mode'] = sb0.Mode
    block_dict['Error'] = sb0.Error
    block_dict['Cov_VnVn'] = sb0.Cov_VnVn
    block_dict['Cov_VeVe'] = sb0.Cov_VeVe
    block_dict['Cov_VuVu'] = sb0.Cov_VuVu
    block_dict['Cov_DtDt'] = sb0.Cov_DtDt
    block_dict['Cov_VnVe'] = sb0.Cov_VnVe
    block_dict['Cov_VnVu'] = sb0.Cov_VnVu
    block_dict['Cov_VnDt'] = sb0.Cov_VnDt
    block_dict['Cov_VeVu'] = sb0.Cov_VeVu
    block_dict['Cov_VeDt'] = sb0.Cov_VeDt
    block_dict['Cov_VuDt'] = sb0.Cov_VuDt

    return block_dict


BLOCKPARSERS['VelCovGeodetic'] = VelCovGeodetic_toDict


def DOP_toDict(c1 * data):
    cdef DOP * sb0
    sb0 = <DOP * >data

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['NrSV'] = sb0.NrSV
    block_dict['PDOP'] = sb0.PDOP
    block_dict['TDOP'] = sb0.TDOP
    block_dict['HDOP'] = sb0.HDOP
    block_dict['VDOP'] = sb0.VDOP
    block_dict['HPL'] = sb0.HPL
    block_dict['VPL'] = sb0.VPL

    return block_dict


BLOCKPARSERS['DOP'] = DOP_toDict


def PosCart_toDict(c1 * data):
    cdef PosCart * sb0
    sb0 = <PosCart * >data

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['Mode'] = sb0.Mode
    block_dict['Error'] = sb0.Error
    block_dict['X'] = sb0.X
    block_dict['Y'] = sb0.Y
    block_dict['Z'] = sb0.Z
    block_dict['Base2RoverX'] = sb0.Base2RoverX
    block_dict['Base2RoverY'] = sb0.Base2RoverY
    block_dict['Base2RoverZ'] = sb0.Base2RoverZ
    block_dict['Cov_xx'] = sb0.Cov_xx
    block_dict['Cov_yy'] = sb0.Cov_yy
    block_dict['Cov_zz'] = sb0.Cov_zz
    block_dict['Cov_xy'] = sb0.Cov_xy
    block_dict['Cov_xz'] = sb0.Cov_xz
    block_dict['Cov_yz'] = sb0.Cov_yz
    block_dict['PDOP'] = sb0.PDOP
    block_dict['HDOP'] = sb0.HDOP
    block_dict['VDOP'] = sb0.VDOP
    block_dict['Misc'] = sb0.Misc
    block_dict['AlertFlag'] = sb0.AlertFlag
    block_dict['Datum'] = sb0.Datum
    block_dict['NrSV'] = sb0.NrSV
    block_dict['WACorrInfo'] = sb0.WACorrInfo
    block_dict['ReferenceID'] = sb0.ReferenceID
    block_dict['MeanCorrAge'] = sb0.MeanCorrAge
    block_dict['SignalInfo'] = sb0.SignalInfo

    return block_dict


BLOCKPARSERS['PosCart'] = PosCart_toDict


def PosLocal_toDict(c1 * data):
    cdef PosLocal * sb0
    sb0 = <PosLocal * >data

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['Mode'] = sb0.Mode
    block_dict['Error'] = sb0.Error
    block_dict['Lat'] = sb0.Lat
    block_dict['Lon'] = sb0.Lon
    block_dict['Alt'] = sb0.Alt
    block_dict['Datum'] = sb0.Datum

    return block_dict


BLOCKPARSERS['PosLocal'] = PosLocal_toDict


def PosProjected_toDict(c1 * data):
    cdef PosProjected * sb0
    sb0 = <PosProjected * >data

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['Mode'] = sb0.Mode
    block_dict['Error'] = sb0.Error
    block_dict['Northing'] = sb0.Northing
    block_dict['Easting'] = sb0.Easting
    block_dict['Alt'] = sb0.Alt
    block_dict['Datum'] = sb0.Datum

    return block_dict


BLOCKPARSERS['PosProjected'] = PosProjected_toDict


def BaseVectorCart_toDict(c1 * data):
    cdef BaseVectorCart * sb0
    cdef BaseVectorCart_VectorInfoCart * sb1
    cdef size_t i

    cdef BaseVectorCart_VectorInfoCart ** sb1s

    sb0 = <BaseVectorCart * >data
    i = sizeof(BaseVectorCart)

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['N'] = sb0.N
    block_dict['SBLength'] = sb0.SBLength

    sb1s = <BaseVectorCart_VectorInfoCart ** >malloc(sb0.N * sizeof(BaseVectorCart_VectorInfoCart * ) )

    sb1_list = [None] * sb0.N
    block_dict['VectorInfoCart'] = sb1_list

    for n in xrange(sb0.N):
        sb1 = sb1s[n] = <BaseVectorCart_VectorInfoCart*>(data + i)
        i += sb0.SBLength
        sb1_dict = dict()
        sb1_list[n] = sb1_dict
        sb1_dict['NrSV'] = sb1.NrSV
        sb1_dict['Error'] = sb1.Error
        sb1_dict['Mode'] = sb1.Mode
        sb1_dict['Misc'] = sb1.Misc
        sb1_dict['DeltaX'] = sb1.DeltaX
        sb1_dict['DeltaY'] = sb1.DeltaY
        sb1_dict['DeltaZ'] = sb1.DeltaZ
        sb1_dict['DeltaVx'] = sb1.DeltaVx
        sb1_dict['DeltaVy'] = sb1.DeltaVy
        sb1_dict['DeltaVz'] = sb1.DeltaVz
        sb1_dict['Azimuth'] = sb1.Azimuth
        sb1_dict['Elevation'] = sb1.Elevation
        sb1_dict['ReferenceID'] = sb1.ReferenceID
        sb1_dict['CorrAge'] = sb1.CorrAge
        sb1_dict['SignalInfo'] = sb1.SignalInfo

    free(sb1s)
    return block_dict


BLOCKPARSERS['BaseVectorCart'] = BaseVectorCart_toDict


def BaseVectorGeod_toDict(c1 * data):
    cdef BaseVectorGeod * sb0
    cdef BaseVectorGeod_VectorInfoGeod * sb1
    cdef size_t i

    cdef BaseVectorGeod_VectorInfoGeod ** sb1s

    sb0 = <BaseVectorGeod * >data
    i = sizeof(BaseVectorGeod)

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['N'] = sb0.N
    block_dict['SBLength'] = sb0.SBLength

    sb1s = <BaseVectorGeod_VectorInfoGeod ** >malloc(sb0.N * sizeof(BaseVectorGeod_VectorInfoGeod * ) )

    sb1_list = [None] * sb0.N
    block_dict['VectorInfoGeod'] = sb1_list

    for n in xrange(sb0.N):
        sb1 = sb1s[n] = <BaseVectorGeod_VectorInfoGeod*>(data + i)
        i += sb0.SBLength
        sb1_dict = dict()
        sb1_list[n] = sb1_dict
        sb1_dict['NrSV'] = sb1.NrSV
        sb1_dict['Error'] = sb1.Error
        sb1_dict['Mode'] = sb1.Mode
        sb1_dict['Misc'] = sb1.Misc
        sb1_dict['DeltaEast'] = sb1.DeltaEast
        sb1_dict['DeltaNorth'] = sb1.DeltaNorth
        sb1_dict['DeltaUp'] = sb1.DeltaUp
        sb1_dict['DeltaVe'] = sb1.DeltaVe
        sb1_dict['DeltaVn'] = sb1.DeltaVn
        sb1_dict['DeltaVu'] = sb1.DeltaVu
        sb1_dict['Azimuth'] = sb1.Azimuth
        sb1_dict['Elevation'] = sb1.Elevation
        sb1_dict['ReferenceID'] = sb1.ReferenceID
        sb1_dict['CorrAge'] = sb1.CorrAge
        sb1_dict['SignalInfo'] = sb1.SignalInfo

    free(sb1s)
    return block_dict


BLOCKPARSERS['BaseVectorGeod'] = BaseVectorGeod_toDict


def EndOfPVT_toDict(c1 * data):
    cdef EndOfPVT * sb0
    sb0 = <EndOfPVT * >data

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc

    return block_dict


BLOCKPARSERS['EndOfPVT'] = EndOfPVT_toDict


def AttEuler_toDict(c1 * data):
    cdef AttEuler * sb0
    sb0 = <AttEuler * >data

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['NrSV'] = sb0.NrSV
    block_dict['Error'] = sb0.Error
    block_dict['Mode'] = sb0.Mode
    block_dict['Heading'] = sb0.Heading
    block_dict['Pitch'] = sb0.Pitch
    block_dict['Roll'] = sb0.Roll
    block_dict['PitchDot'] = sb0.PitchDot
    block_dict['RollDot'] = sb0.RollDot
    block_dict['HeadingDot'] = sb0.HeadingDot

    return block_dict


BLOCKPARSERS['AttEuler'] = AttEuler_toDict


def AttCovEuler_toDict(c1 * data):
    cdef AttCovEuler * sb0
    sb0 = <AttCovEuler * >data

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['Error'] = sb0.Error
    block_dict['Cov_HeadHead'] = sb0.Cov_HeadHead
    block_dict['Cov_PitchPitch'] = sb0.Cov_PitchPitch
    block_dict['Cov_RollRoll'] = sb0.Cov_RollRoll
    block_dict['Cov_HeadPitch'] = sb0.Cov_HeadPitch
    block_dict['Cov_HeadRoll'] = sb0.Cov_HeadRoll
    block_dict['Cov_PitchRoll'] = sb0.Cov_PitchRoll

    return block_dict


BLOCKPARSERS['AttCovEuler'] = AttCovEuler_toDict


def EndOfAtt_toDict(c1 * data):
    cdef EndOfAtt * sb0
    sb0 = <EndOfAtt * >data

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc

    return block_dict


BLOCKPARSERS['EndOfAtt'] = EndOfAtt_toDict


def ReceiverTime_toDict(c1 * data):
    cdef ReceiverTime * sb0
    sb0 = <ReceiverTime * >data

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['UTCYear'] = sb0.UTCYear
    block_dict['UTCMonth'] = sb0.UTCMonth
    block_dict['UTCDay'] = sb0.UTCDay
    block_dict['UTCHour'] = sb0.UTCHour
    block_dict['UTCMin'] = sb0.UTCMin
    block_dict['UTCSec'] = sb0.UTCSec
    block_dict['DeltaLS'] = sb0.DeltaLS
    block_dict['SyncLevel'] = sb0.SyncLevel

    return block_dict


BLOCKPARSERS['ReceiverTime'] = ReceiverTime_toDict


def xPPSOffset_toDict(c1 * data):
    cdef xPPSOffset * sb0
    sb0 = <xPPSOffset * >data

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['SyncAge'] = sb0.SyncAge
    block_dict['Timescale'] = sb0.Timescale
    block_dict['Offset'] = sb0.Offset

    return block_dict


BLOCKPARSERS['xPPSOffset'] = xPPSOffset_toDict


def ExtEvent_toDict(c1 * data):
    cdef ExtEvent * sb0
    sb0 = <ExtEvent * >data

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['Source'] = sb0.Source
    block_dict['Polarity'] = sb0.Polarity
    block_dict['Offset'] = sb0.Offset
    block_dict['RxClkBias'] = sb0.RxClkBias
    block_dict['PVTAge'] = sb0.PVTAge

    return block_dict


BLOCKPARSERS['ExtEvent'] = ExtEvent_toDict


def ExtEventPVTCartesian_toDict(c1 * data):
    cdef ExtEventPVTCartesian * sb0
    sb0 = <ExtEventPVTCartesian * >data

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['Mode'] = sb0.Mode
    block_dict['Error'] = sb0.Error
    block_dict['X'] = sb0.X
    block_dict['Y'] = sb0.Y
    block_dict['Z'] = sb0.Z
    block_dict['Undulation'] = sb0.Undulation
    block_dict['Vx'] = sb0.Vx
    block_dict['Vy'] = sb0.Vy
    block_dict['Vz'] = sb0.Vz
    block_dict['COG'] = sb0.COG
    block_dict['RxClkBias'] = sb0.RxClkBias
    block_dict['RxClkDrift'] = sb0.RxClkDrift
    block_dict['TimeSystem'] = sb0.TimeSystem
    block_dict['Datum'] = sb0.Datum
    block_dict['NrSV'] = sb0.NrSV
    block_dict['WACorrInfo'] = sb0.WACorrInfo
    block_dict['ReferenceID'] = sb0.ReferenceID
    block_dict['MeanCorrAge'] = sb0.MeanCorrAge
    block_dict['SignalInfo'] = sb0.SignalInfo
    block_dict['AlertFlag'] = sb0.AlertFlag
    block_dict['NrBases'] = sb0.NrBases
    block_dict['PPPInfo'] = sb0.PPPInfo
    block_dict['Latency'] = sb0.Latency
    block_dict['HAccuracy'] = sb0.HAccuracy
    block_dict['VAccuracy'] = sb0.VAccuracy
    block_dict['Misc'] = sb0.Misc

    return block_dict


BLOCKPARSERS['ExtEventPVTCartesian'] = ExtEventPVTCartesian_toDict


def ExtEventPVTGeodetic_toDict(c1 * data):
    cdef ExtEventPVTGeodetic * sb0
    sb0 = <ExtEventPVTGeodetic * >data

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['Mode'] = sb0.Mode
    block_dict['Error'] = sb0.Error
    block_dict['Latitude'] = sb0.Latitude
    block_dict['Longitude'] = sb0.Longitude
    block_dict['Height'] = sb0.Height
    block_dict['Undulation'] = sb0.Undulation
    block_dict['Vn'] = sb0.Vn
    block_dict['Ve'] = sb0.Ve
    block_dict['Vu'] = sb0.Vu
    block_dict['COG'] = sb0.COG
    block_dict['RxClkBias'] = sb0.RxClkBias
    block_dict['RxClkDrift'] = sb0.RxClkDrift
    block_dict['TimeSystem'] = sb0.TimeSystem
    block_dict['Datum'] = sb0.Datum
    block_dict['NrSV'] = sb0.NrSV
    block_dict['WACorrInfo'] = sb0.WACorrInfo
    block_dict['ReferenceID'] = sb0.ReferenceID
    block_dict['MeanCorrAge'] = sb0.MeanCorrAge
    block_dict['SignalInfo'] = sb0.SignalInfo
    block_dict['AlertFlag'] = sb0.AlertFlag
    block_dict['NrBases'] = sb0.NrBases
    block_dict['PPPInfo'] = sb0.PPPInfo
    block_dict['Latency'] = sb0.Latency
    block_dict['HAccuracy'] = sb0.HAccuracy
    block_dict['VAccuracy'] = sb0.VAccuracy
    block_dict['Misc'] = sb0.Misc

    return block_dict


BLOCKPARSERS['ExtEventPVTGeodetic'] = ExtEventPVTGeodetic_toDict

def ExtEventBaseVectGeod_toDict(c1 * data):
    cdef ExtEventBaseVectGeod * sb0
    cdef ExtEventVectorInfoGeod * sb1
    cdef size_t i

    cdef ExtEventVectorInfoGeod ** sb1s

    sb0 = <ExtEventBaseVectGeod * >data
    i = sizeof(ExtEventBaseVectGeod)

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['N'] = sb0.N
    block_dict['SBLength'] = sb0.SBLength

    sb1s = <ExtEventVectorInfoGeod ** >malloc(sb0.N * sizeof(ExtEventVectorInfoGeod * ) )

    sb1_list = [None] * sb0.N
    block_dict['ExtEventVectorInfoGeod'] = sb1_list

    for n in xrange(sb0.N):
        sb1 = sb1s[n] = <ExtEventVectorInfoGeod*>(data + i)
        i += sb0.SBLength
        sb1_dict = dict()
        sb1_list[n] = sb1_dict
        sb1_dict['NrSV'] = sb1.NrSV
        sb1_dict['Error'] = sb1.Error
        sb1_dict['Mode'] = sb1.Mode
        sb1_dict['Misc'] = sb1.Misc
        sb1_dict['DeltaEast'] = sb1.DeltaEast
        sb1_dict['DeltaNorth'] = sb1.DeltaNorth
        sb1_dict['DeltaUp'] = sb1.DeltaUp
        sb1_dict['DeltaVe'] = sb1.DeltaVe
        sb1_dict['DeltaVn'] = sb1.DeltaVn
        sb1_dict['DeltaVu'] = sb1.DeltaVu
        sb1_dict['Azimuth'] = sb1.Azimuth
        sb1_dict['Elevation'] = sb1.Elevation
        sb1_dict['ReferenceID'] = sb1.ReferenceID
        sb1_dict['CorrAge'] = sb1.CorrAge
        sb1_dict['SignalInfo'] = sb1.SignalInfo

    free(sb1s)
    return block_dict


BLOCKPARSERS['ExtEventBaseVectGeod'] = ExtEventBaseVectGeod_toDict

def ExtEventAttEuler_toDict(c1 * data):
    cdef ExtEventAttEuler * sb0
    sb0 = <ExtEventAttEuler * >data

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['NrSV'] = sb0.NrSV
    block_dict['Error'] = sb0.Error
    block_dict['Mode'] = sb0.Mode
    block_dict['Heading'] = sb0.Heading
    block_dict['Pitch'] = sb0.Pitch
    block_dict['Roll'] = sb0.Roll
    block_dict['PitchDot'] = sb0.PitchDot
    block_dict['RollDot'] = sb0.RollDot
    block_dict['HeadingDot'] = sb0.HeadingDot

    return block_dict


BLOCKPARSERS['ExtEventAttEuler'] = ExtEventAttEuler_toDict


def DiffCorrIn_toDict(c1 * data):
    cdef DiffCorrIn * sb0
    sb0 = <DiffCorrIn * >data

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['Mode'] = sb0.Mode
    block_dict['Source'] = sb0.Source
    block_dict['MessageContent'] = <c1*> & sb0.MessageContent

    return block_dict


BLOCKPARSERS['DiffCorrIn'] = DiffCorrIn_toDict


def BaseStation_toDict(c1 * data):
    cdef BaseStation * sb0
    sb0 = <BaseStation * >data

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['BaseStationID'] = sb0.BaseStationID
    block_dict['BaseType'] = sb0.BaseType
    block_dict['Source'] = sb0.Source
    block_dict['Datum'] = sb0.Datum
    block_dict['X'] = sb0.X
    block_dict['Y'] = sb0.Y
    block_dict['Z'] = sb0.Z

    return block_dict


BLOCKPARSERS['BaseStation'] = BaseStation_toDict


def RTCMDatum_toDict(c1 * data):
    cdef RTCMDatum * sb0
    sb0 = <RTCMDatum * >data

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['SourceCRS'] = sb0.SourceCRS
    block_dict['TargetCRS'] = sb0.TargetCRS
    block_dict['Datum'] = sb0.Datum
    block_dict['HeightType'] = sb0.HeightType
    block_dict['QualityInd'] = sb0.QualityInd

    return block_dict


BLOCKPARSERS['RTCMDatum'] = RTCMDatum_toDict


def LBandTrackerStatus_toDict(c1 * data):
    cdef LBandTrackerStatus * sb0
    cdef LBandTrackerStatus_TrackData * sb1
    cdef size_t i

    cdef LBandTrackerStatus_TrackData ** sb1s

    sb0 = <LBandTrackerStatus * >data
    i = sizeof(LBandTrackerStatus)

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['N'] = sb0.N
    block_dict['SBLength'] = sb0.SBLength

    sb1s = <LBandTrackerStatus_TrackData ** >malloc(sb0.N * sizeof(LBandTrackerStatus_TrackData * ) )

    sb1_list = [None] * sb0.N
    block_dict['TrackData'] = sb1_list

    for n in xrange(sb0.N):
        sb1 = sb1s[n] = <LBandTrackerStatus_TrackData*>(data + i)
        i += sb0.SBLength
        sb1_dict = dict()
        sb1_list[n] = sb1_dict
        sb1_dict['Frequency'] = sb1.Frequency
        sb1_dict['Baudrate'] = sb1.Baudrate
        sb1_dict['ServiceID'] = sb1.ServiceID
        sb1_dict['FreqOffset'] = sb1.FreqOffset
        sb1_dict['CN0'] = sb1.CN0
        sb1_dict['AvgPower'] = sb1.AvgPower
        sb1_dict['AGCGain'] = sb1.AGCGain
        sb1_dict['Mode'] = sb1.Mode
        sb1_dict['Status'] = sb1.Status
        sb1_dict['SVID'] = sb1.SVID
        sb1_dict['LockTime'] = sb1.LockTime
        sb1_dict['Source'] = sb1.Source

    free(sb1s)
    return block_dict


BLOCKPARSERS['LBandTrackerStatus'] = LBandTrackerStatus_toDict


def LBandBeams_toDict(c1 * data):
    cdef LBandBeams * sb0
    cdef Beaminfo * sb1
    cdef size_t i

    cdef Beaminfo ** sb1s

    sb0 = <LBandBeams * >data
    i = sizeof(LBandBeams)

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['N'] = sb0.N
    block_dict['SBLength'] = sb0.SBLength

    sb1s = <Beaminfo ** >malloc(sb0.N * sizeof(Beaminfo * ) )

    sb1_list = [None] * sb0.N
    block_dict['Beaminfo'] = sb1_list

    for n in xrange(sb0.N):
        sb1 = sb1s[n] = <Beaminfo*>(data + i)
        i += sb0.SBLength
        sb1_dict = dict()
        sb1_list[n] = sb1_dict
        sb1_dict['SVID'] = sb1.SVID
        block_dict['SatName'] = (< c1*>&sb1.SatName)[0:9]
        sb1_dict['SatLongitude'] = sb1.SatLongitude
        sb1_dict['BeamFreq'] = sb1.BeamFreq

    free(sb1s)
    return block_dict


BLOCKPARSERS['LBandBeams'] = LBandBeams_toDict


def LBandRaw_toDict(c1 * data):
    cdef LBandRaw * sb0
    sb0 = <LBandRaw * >data

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['N'] = sb0.N
    block_dict['Frequency'] = sb0.Frequency
    block_dict['UserData'] = (< c1*>&sb0.UserData)[0:sb0.N]
    block_dict['Channel'] = sb0.Channel

    return block_dict


BLOCKPARSERS['LBandRaw'] = LBandRaw_toDict


def FugroStatus_toDict(c1 * data):
    cdef FugroStatus * sb0
    sb0 = <FugroStatus * >data

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['Status'] = sb0.Status
    block_dict['SubStartingTime'] = sb0.SubStartingTime
    block_dict['SubExpirationTime'] = sb0.SubExpirationTime
    block_dict['SubHourGlass'] = sb0.SubHourGlass
    block_dict['SubscribedMode'] = sb0.SubscribedMode
    block_dict['SubCurrentMode'] = sb0.SubCurrentMode
    block_dict['SubLinkVector'] = sb0.SubLinkVector
    block_dict['CRCGoodCount'] = sb0.CRCGoodCount
    block_dict['CRCBadCount'] = sb0.CRCBadCount
    block_dict['LbandTrackerStatusIdx'] = sb0.LbandTrackerStatusIdx

    return block_dict


BLOCKPARSERS['FugroStatus'] = FugroStatus_toDict


def ChannelStatus_toDict(c1 * data):
    cdef ChannelStatus * sb0
    cdef ChannelStatus_ChannelSatInfo * sb1
    cdef ChannelStatus_ChannelStateInfo * sb2
    cdef size_t i

    cdef ChannelStatus_ChannelSatInfo ** sb1s
    cdef ChannelStatus_ChannelStateInfo ** *sb2s

    sb0 = <ChannelStatus * >data
    i = sizeof(ChannelStatus)

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['N1'] = sb0.N1
    block_dict['SB1Length'] = sb0.SB1Length
    block_dict['SB2Length'] = sb0.SB2Length

    sb1s = <ChannelStatus_ChannelSatInfo ** >malloc(sb0.N1 * sizeof(ChannelStatus_ChannelSatInfo * ) )
    sb2s = <ChannelStatus_ChannelStateInfo ** * > malloc(sb0.N1 * sizeof(ChannelStatus_ChannelSatInfo * ) )

    sb1_list = [None] * sb0.N1
    block_dict['ChannelSatInfo'] = sb1_list

    for n1 in xrange(sb0.N1):
        sb1 = sb1s[n1] = <ChannelStatus_ChannelSatInfo*>(data + i)
        i += sb0.SB1Length
        sb1_dict = dict()
        sb1_list[n1] = sb1_dict
        sb1_dict['SVID'] = sb1.SVID
        sb1_dict['FreqNr'] = sb1.FreqNr
        sb1_dict['Azimuth_RiseSet'] = sb1.Azimuth_RiseSet
        sb1_dict['HealthStatus'] = sb1.HealthStatus
        sb1_dict['Elevation'] = sb1.Elevation
        sb1_dict['N2'] = sb1.N2
        sb1_dict['RxChannel'] = sb1.RxChannel

        sb2s[n1] = <ChannelStatus_ChannelStateInfo ** >malloc(sb1.N2 * sizeof(ChannelStatus_ChannelStateInfo * ) )
        sb2_list = [None] * sb1.N2
        sb1_dict['ChannelStateInfo'] = sb2_list

        for n2 in xrange(sb1.N2):
            sb2 = sb2s[n1][n2] = <ChannelStatus_ChannelStateInfo*>(data + i)
            i += sb0.SB2Length
            sb2_dict = dict()
            sb2_list[n2] = sb2_dict
            sb2_dict['Antenna'] = sb2.Antenna
            sb2_dict['TrackingStatus'] = sb2.TrackingStatus
            sb2_dict['PVTStatus'] = sb2.PVTStatus
            sb2_dict['PVTInfo'] = sb2.PVTInfo

        free(sb2s[n1])
    free(sb2s)
    free(sb1s)
    return block_dict


BLOCKPARSERS['ChannelStatus'] = ChannelStatus_toDict


def ReceiverStatus_toDict(c1 * data):
    cdef ReceiverStatus * sb0
    cdef ReceiverStatus_AGCState * sb1
    cdef size_t i

    cdef ReceiverStatus_AGCState ** sb1s

    sb0 = <ReceiverStatus * >data
    i = sizeof(ReceiverStatus)

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['CPULoad'] = sb0.CPULoad
    block_dict['ExtError'] = sb0.ExtError
    block_dict['UpTime'] = sb0.UpTime
    block_dict['RxState'] = sb0.RxState
    block_dict['RxError'] = sb0.RxError
    block_dict['N'] = sb0.N
    block_dict['SBLength'] = sb0.SBLength
    block_dict['CmdCount'] = sb0.CmdCount
    block_dict['Temperature'] = sb0.Temperature

    sb1s = <ReceiverStatus_AGCState ** >malloc(sb0.N * sizeof(ReceiverStatus_AGCState * ) )

    sb1_list = [None] * sb0.N
    block_dict['AGCData'] = sb1_list

    for n in xrange(sb0.N):
        sb1 = sb1s[n] = <ReceiverStatus_AGCState*>(data + i)
        i += sb0.SBLength
        sb1_dict = dict()
        sb1_list[n] = sb1_dict
        sb1_dict['FrontendID'] = sb1.FrontendID
        sb1_dict['Gain'] = sb1.Gain
        sb1_dict['SampleVar'] = sb1.SampleVar
        sb1_dict['BlankingStat'] = sb1.BlankingStat

    free(sb1s)
    return block_dict


BLOCKPARSERS['ReceiverStatus'] = ReceiverStatus_toDict


def SatVisibility_toDict(c1 * data):
    cdef SatVisibility * sb0
    cdef SatVisibility_SatInfo * sb1
    cdef size_t i

    cdef SatVisibility_SatInfo ** sb1s

    sb0 = <SatVisibility * >data
    i = sizeof(SatVisibility)

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['N'] = sb0.N
    block_dict['SBLength'] = sb0.SBLength

    sb1s = <SatVisibility_SatInfo ** >malloc(sb0.N * sizeof(SatVisibility_SatInfo * ) )

    sb1_list = [None] * sb0.N
    block_dict['SatInfo'] = sb1_list

    for n in xrange(sb0.N):
        sb1 = sb1s[n] = <SatVisibility_SatInfo*>(data + i)
        i += sb0.SBLength
        sb1_dict = dict()
        sb1_list[n] = sb1_dict
        sb1_dict['SVID'] = sb1.SVID
        sb1_dict['FreqNr'] = sb1.FreqNr
        sb1_dict['Azimuth'] = sb1.Azimuth
        sb1_dict['Elevation'] = sb1.Elevation
        sb1_dict['RiseSet'] = sb1.RiseSet
        sb1_dict['SatelliteInfo'] = sb1.SatelliteInfo

    free(sb1s)
    return block_dict


BLOCKPARSERS['SatVisibility'] = SatVisibility_toDict


def InputLink_toDict(c1 * data):
    cdef InputLink * sb0
    cdef InputLink_InputStats * sb1
    cdef size_t i

    cdef InputLink_InputStats ** sb1s

    sb0 = <InputLink * >data
    i = sizeof(InputLink)

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['N'] = sb0.N
    block_dict['SBLength'] = sb0.SBLength

    sb1s = <InputLink_InputStats ** >malloc(sb0.N * sizeof(InputLink_InputStats * ) )

    sb1_list = [None] * sb0.N
    block_dict['InputStats'] = sb1_list

    for n in xrange(sb0.N):
        sb1 = sb1s[n] = <InputLink_InputStats*>(data + i)
        i += sb0.SBLength
        sb1_dict = dict()
        sb1_list[n] = sb1_dict
        sb1_dict['CD'] = sb1.CD
        sb1_dict['Type'] = sb1.Type
        sb1_dict['AgeOfLastMessage'] = sb1.AgeOfLastMessage
        sb1_dict['NrBytesReceived'] = sb1.NrBytesReceived
        sb1_dict['NrBytesAccepted'] = sb1.NrBytesAccepted
        sb1_dict['NrMsgReceived'] = sb1.NrMsgReceived
        sb1_dict['NrMsgAccepted'] = sb1.NrMsgAccepted

    free(sb1s)
    return block_dict


BLOCKPARSERS['InputLink'] = InputLink_toDict


def OutputLink_toDict(c1 * data):
    cdef OutputLink * sb0
    cdef OutputLink_OutputStats * sb1
    cdef OutputLink_OutputType * sb2
    cdef size_t i

    cdef OutputLink_OutputStats ** sb1s
    cdef OutputLink_OutputType ** *sb2s

    sb0 = <OutputLink * >data
    i = sizeof(OutputLink)

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['N1'] = sb0.N1
    block_dict['SB1Length'] = sb0.SB1Length
    block_dict['SB2Length'] = sb0.SB2Length

    sb1s = <OutputLink_OutputStats ** >malloc(sb0.N1 * sizeof(OutputLink_OutputStats * ) )
    sb2s = <OutputLink_OutputType ** * > malloc(sb0.N1 * sizeof(OutputLink_OutputStats * ) )

    sb1_list = [None] * sb0.N1
    block_dict['OutputStats'] = sb1_list

    for n1 in xrange(sb0.N1):
        sb1 = sb1s[n1] = <OutputLink_OutputStats*>(data + i)
        i += sb0.SB1Length
        sb1_dict = dict()
        sb1_list[n1] = sb1_dict
        sb1_dict['CD'] = sb1.CD
        sb1_dict['N2'] = sb1.N2
        sb1_dict['AllowedRate'] = sb1.AllowedRate
        sb1_dict['NrBytesProduced'] = sb1.NrBytesProduced
        sb1_dict['NrBytesSent'] = sb1.NrBytesSent
        sb1_dict['NrClients'] = sb1.NrClients

        sb2s[n1] = <OutputLink_OutputType ** >malloc(sb1.N2 * sizeof(OutputLink_OutputType * ) )
        sb2_list = [None] * sb1.N2
        sb1_dict['OutputType'] = sb2_list

        for n2 in xrange(sb1.N2):
            sb2 = sb2s[n1][n2] = <OutputLink_OutputType*>(data + i)
            i += sb0.SB2Length
            sb2_dict = dict()
            sb2_list[n2] = sb2_dict
            sb2_dict['Type'] = sb2.Type
            sb2_dict['Percentage'] = sb2.Percentage

        free(sb2s[n1])
    free(sb2s)
    free(sb1s)
    return block_dict


BLOCKPARSERS['OutputLink'] = OutputLink_toDict


def NTRIPClientStatus_toDict(c1 * data):
    cdef NTRIPClientStatus * sb0
    cdef NTRIPClientConnection * sb1
    cdef size_t i

    cdef NTRIPClientConnection ** sb1s

    sb0 = <NTRIPClientStatus * >data
    i = sizeof(NTRIPClientStatus)

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['N'] = sb0.N
    block_dict['SBLength'] = sb0.SBLength

    sb1s = <NTRIPClientConnection ** >malloc(sb0.N * sizeof(NTRIPClientConnection * ) )

    sb1_list = [None] * sb0.N
    block_dict['NTRIPClientConnection'] = sb1_list

    for n in xrange(sb0.N):
        sb1 = sb1s[n] = <NTRIPClientConnection*>(data + i)
        i += sb0.SBLength
        sb1_dict = dict()
        sb1_list[n] = sb1_dict
        sb1_dict['CDIndex'] = sb1.CDIndex
        sb1_dict['Status'] = sb1.Status
        sb1_dict['ErrorCode'] = sb1.ErrorCode
        sb1_dict['Info'] = sb1.Info

    free(sb1s)
    return block_dict


BLOCKPARSERS['NTRIPClientStatus'] = NTRIPClientStatus_toDict


def NTRIPServerStatus_toDict(c1 * data):
    cdef NTRIPServerStatus * sb0
    cdef NTRIPServerConnection * sb1
    cdef size_t i

    cdef NTRIPServerConnection ** sb1s

    sb0 = <NTRIPServerStatus * >data
    i = sizeof(NTRIPServerStatus)

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['N'] = sb0.N
    block_dict['SBLength'] = sb0.SBLength

    sb1s = <NTRIPServerConnection ** >malloc(sb0.N * sizeof(NTRIPServerConnection * ) )

    sb1_list = [None] * sb0.N
    block_dict['NTRIPServerConnection'] = sb1_list

    for n in xrange(sb0.N):
        sb1 = sb1s[n] = <NTRIPServerConnection*>(data + i)
        i += sb0.SBLength
        sb1_dict = dict()
        sb1_list[n] = sb1_dict
        sb1_dict['CDIndex'] = sb1.CDIndex
        sb1_dict['Status'] = sb1.Status
        sb1_dict['ErrorCode'] = sb1.ErrorCode
        sb1_dict['Info'] = sb1.Info

    free(sb1s)
    return block_dict


BLOCKPARSERS['NTRIPServerStatus'] = NTRIPServerStatus_toDict


def IPStatus_toDict(c1 * data):
    cdef IPStatus * sb0
    sb0 = <IPStatus * >data

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['MACAddress'] = (< c1*>sb0.MACAddress)[0:6]
    block_dict['IPAddress'] = (< c1*>sb0.IPAddress)[0:16]
    block_dict['Gateway'] = (< c1*>sb0.Gateway)[0:16]
    block_dict['Netmask'] = sb0.Netmask
    block_dict['Host_Name'] = (< c1*>sb0.Gateway)[0:33]

    return block_dict


BLOCKPARSERS['IPStatus'] = IPStatus_toDict


def DynDNSStatus_toDict(c1 * data):
    cdef DynDNSStatus * sb0
    sb0 = <DynDNSStatus * >data

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['Status'] = sb0.Status
    block_dict['ErrorCode'] = sb0.ErrorCode
    block_dict['IPAddress'] = (< c1*>sb0.IPAddress)[0:16]

    return block_dict


BLOCKPARSERS['DynDNSStatus'] = DynDNSStatus_toDict


def QualityInd_toDict(c1 * data):
    cdef QualityInd * sb0
    sb0 = <QualityInd * >data

    i = sizeof(QualityInd)

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['N'] = sb0.N
    block_dict['Indicators'] = (< c1*>&sb0.N)[0:2*sb0.N]

    return block_dict


BLOCKPARSERS['QualityInd'] = QualityInd_toDict


def DiskStatus_toDict(c1 * data):
    cdef DiskStatus * sb0
    cdef DiskData * sb1
    cdef size_t i

    cdef DiskData ** sb1s

    sb0 = <DiskStatus * >data
    i = sizeof(DiskStatus)

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['N'] = sb0.N
    block_dict['SBLength'] = sb0.SBLength

    sb1s = <DiskData ** >malloc(sb0.N * sizeof(DiskData * ) )

    sb1_list = [None] * sb0.N
    block_dict['DiskData'] = sb1_list

    for n in xrange(sb0.N):
        sb1 = sb1s[n] = <DiskData*>(data + i)
        i += sb0.SBLength
        sb1_dict = dict()
        sb1_list[n] = sb1_dict
        sb1_dict['DiskID'] = sb1.DiskID
        sb1_dict['Status'] = sb1.Status
        sb1_dict['DiskUsageMSB'] = sb1.DiskUsageMSB
        sb1_dict['DiskUsageLSB'] = sb1.DiskUsageLSB
        sb1_dict['DiskSize'] = sb1.DiskSize
        sb1_dict['CreateDeleteCount'] = sb1.CreateDeleteCount
        sb1_dict['Error'] = sb1.Error

    free(sb1s)
    return block_dict


BLOCKPARSERS['DiskStatus'] = DiskStatus_toDict


def RFStatus_toDict(c1 * data):
    cdef RFStatus * sb0
    cdef RFBand * sb1
    cdef size_t i

    cdef RFBand ** sb1s

    sb0 = <RFStatus * >data
    i = sizeof(RFStatus)

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['N'] = sb0.N
    block_dict['SBLength'] = sb0.SBLength
    block_dict['Flags'] = sb0.Flags

    sb1s = <RFBand ** >malloc(sb0.N * sizeof(RFBand * ) )

    sb1_list = [None] * sb0.N
    block_dict['RFBand'] = sb1_list

    for n in xrange(sb0.N):
        sb1 = sb1s[n] = <RFBand*>(data + i)
        i += sb0.SBLength
        sb1_dict = dict()
        sb1_list[n] = sb1_dict
        sb1_dict['Frequency'] = sb1.Frequency
        sb1_dict['Bandwidth'] = sb1.Bandwidth
        sb1_dict['Info'] = sb1.Info

    free(sb1s)
    return block_dict


BLOCKPARSERS['RFStatus'] = RFStatus_toDict


def P2PPStatus_toDict(c1 * data):
    cdef P2PPStatus * sb0
    cdef P2PPSession * sb1
    cdef size_t i

    cdef P2PPSession ** sb1s

    sb0 = <P2PPStatus * >data
    i = sizeof(P2PPStatus)

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['N'] = sb0.N
    block_dict['SBLength'] = sb0.SBLength

    sb1s = <P2PPSession ** >malloc(sb0.N * sizeof(P2PPSession * ) )

    sb1_list = [None] * sb0.N
    block_dict['P2PPSession'] = sb1_list

    for n in xrange(sb0.N):
        sb1 = sb1s[n] = <P2PPSession*>(data + i)
        i += sb0.SBLength
        sb1_dict = dict()
        sb1_list[n] = sb1_dict
        sb1_dict['SessionID'] = sb1.SessionID
        sb1_dict['Port'] = sb1.Port
        sb1_dict['Status'] = sb1.Status
        sb1_dict['ErrorCode'] = sb1.ErrorCode

    free(sb1s)
    return block_dict


BLOCKPARSERS['P2PPStatus'] = P2PPStatus_toDict


def CosmosStatus_toDict(c1 * data):
    cdef CosmosStatus * sb0
    sb0 = <CosmosStatus * >data

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['Status'] = sb0.Status

    return block_dict


BLOCKPARSERS['CosmosStatus'] = CosmosStatus_toDict


def GALAuthStatus_toDict(c1 * data):
    cdef GALAuthStatus * sb0
    sb0 = <GALAuthStatus * >data

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['OSNMAStatus'] = sb0.OSNMAStatus
    block_dict['TrustedTimeDelta'] = sb0.TrustedTimeDelta
    block_dict['GalActiveMask'] = sb0.GalActiveMask
    block_dict['GalAuthenticMask'] = sb0.GalAuthenticMask
    block_dict['GpsActiveMask'] = sb0.GpsActiveMask
    block_dict['GpsAuthenticMask'] = sb0.GpsAuthenticMask

    return block_dict


BLOCKPARSERS['GALAuthStatus'] = GALAuthStatus_toDict


def ReceiverSetup_toDict(c1 * data):
    cdef ReceiverSetup * sb0
    sb0 = <ReceiverSetup * >data

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['MarkerName'] = (< c1*>sb0.MarkerName)[0:60]
    block_dict['MarkerNumber'] = (< c1*>sb0.MarkerNumber)[0:20]
    block_dict['Observer'] = (< c1*>sb0.Observer)[0:20]
    block_dict['Agency'] = (< c1*>sb0.Agency)[0:40]
    block_dict['RxSerialNumber'] = (< c1*>sb0.RxSerialNumber)[0:20]
    block_dict['RxName'] = (< c1*>sb0.RxName)[0:20]
    block_dict['RxVersion'] = (< c1*>sb0.RxVersion)[0:20]
    block_dict['AntSerialNbr'] = (< c1*>sb0.AntSerialNbr)[0:20]
    block_dict['AntType'] = (< c1*>sb0.AntType)[0:20]
    block_dict['DeltaH'] = sb0.DeltaH
    block_dict['DeltaE'] = sb0.DeltaE
    block_dict['DeltaN'] = sb0.DeltaN
    block_dict['MarkerType'] = (< c1*>sb0.MarkerType)[0:20]
    block_dict['GNSSFWVersion'] = (< c1*>sb0.GNSSFWVersion)[0:40]
    block_dict['ProductName'] = (< c1*>sb0.ProductName)[0:40]
    block_dict['Latitude'] = sb0.Latitude
    block_dict['Longitude'] = sb0.Longitude
    block_dict['Height'] = sb0.Height
    block_dict['StationCode'] = (< c1*>sb0.StationCode)[0:10]
    block_dict['MonumentIdx'] = sb0.MonumentIdx
    block_dict['ReceiverIdx'] = sb0.ReceiverIdx
    block_dict['CountryCode'] = (< c1*>sb0.CountryCode)[0:3]

    return block_dict


BLOCKPARSERS['ReceiverSetup'] = ReceiverSetup_toDict


def RxMessage_toDict(c1 * data):
    cdef RxMessage * sb0
    sb0 = <RxMessage * >data

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['Type'] = sb0.Type
    block_dict['Severity'] = sb0.Severity
    block_dict['MessageID'] = sb0.MessageID
    block_dict['StringLn'] = sb0.StringLn

    block_dict['Message'] = (< c1*>&sb0.Message)[0:sb0.StringLn]

    return block_dict


BLOCKPARSERS['RxMessage'] = RxMessage_toDict


def Commands_toDict(c1 * data):
    cdef Commands * sb0
    sb0 = <Commands * >data

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['CmdData'] = <c1*> & sb0.CmdData

    return block_dict


BLOCKPARSERS['Commands'] = Commands_toDict


def Comment_toDict(c1 * data):
    cdef Comment * sb0
    sb0 = <Comment * >data

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['CommentLn'] = sb0.CommentLn

    block_dict['Comment'] = (< c1*>&sb0.Comment)[0:sb0.CommentLn]

    return block_dict


BLOCKPARSERS['Comment'] = Comment_toDict


def BBSamples_toDict(c1 * data):
    cdef BBSamples * sb0
    sb0 = <BBSamples * >data

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['N'] = sb0.N
    block_dict['Info'] = sb0.Info
    block_dict['SampleFreq'] = sb0.SampleFreq
    block_dict['LOFreq'] = sb0.LOFreq

    block_dict['Samples'] = (< c1*>&sb0.Samples)[0:2*sb0.N]

    return block_dict


BLOCKPARSERS['BBSamples'] = BBSamples_toDict


def ASCIIIn_toDict(c1 * data):
    cdef ASCIIIn * sb0
    sb0 = <ASCIIIn * >data

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['CD'] = sb0.CD
    block_dict['StringLn'] = sb0.StringLn
    block_dict['SensorModel'] = (< c1*>&sb0.SensorModel)[0:20]
    block_dict['SensorType'] = (< c1*>&sb0.SensorType)[0:20]
    block_dict['ASCIIString'] = (< c1*>&sb0.ASCIIString)[0:sb0.StringLn]

    return block_dict


BLOCKPARSERS['ASCIIIn'] = ASCIIIn_toDict


def EncapsulatedOutput_toDict(c1 * data):
    cdef EncapsulatedOutput * sb0
    sb0 = <EncapsulatedOutput * >data

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['Mode'] = sb0.Mode
    block_dict['N'] = sb0.N
    block_dict['Payload'] = (< c1*>&sb0.Payload)[0:sb0.N]

    return block_dict


BLOCKPARSERS['EncapsulatedOutput'] = EncapsulatedOutput_toDict


def GISAction_toDict(c1 * data):
    cdef GISAction * sb0
    sb0 = <GISAction * >data

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['CommentLn'] = sb0.CommentLn
    block_dict['ItemIDMSB'] = sb0.ItemIDMSB
    block_dict['ItemIDLSB'] = sb0.ItemIDLSB
    block_dict['Action'] = sb0.Action
    block_dict['Trigger'] = sb0.Trigger
    block_dict['Database'] = sb0.Database

    block_dict['Comment'] = (< c1*>&sb0.Comment)[0:sb0.CommentLn]

    return block_dict


BLOCKPARSERS['GISAction'] = GISAction_toDict


def GISStatus_toDict(c1 * data):
    cdef GISStatus * sb0
    cdef DatabaseStatus * sb1
    cdef size_t i

    cdef DatabaseStatus ** sb1s

    sb0 = <GISStatus * >data
    i = sizeof(GISStatus)

    block_dict = dict()
    block_dict['TOW'] = sb0.TOW
    block_dict['WNc'] = sb0.WNc
    block_dict['N'] = sb0.N
    block_dict['SBLength'] = sb0.SBLength

    sb1s = <DatabaseStatus ** >malloc(sb0.N * sizeof(DatabaseStatus * ) )

    sb1_list = [None] * sb0.N
    block_dict['DatabaseStatus'] = sb1_list

    for n in xrange(sb0.N):
        sb1 = sb1s[n] = <DatabaseStatus*>(data + i)
        i += sb0.SBLength
        sb1_dict = dict()
        sb1_list[n] = sb1_dict
        sb1_dict['Database'] = sb1.Database
        sb1_dict['OnlineStatus'] = sb1.OnlineStatus
        sb1_dict['Error'] = sb1.Error
        sb1_dict['NrItems'] = sb1.NrItems
        sb1_dict['NrNotSync'] = sb1.NrNotSync

    free(sb1s)
    return block_dict


BLOCKPARSERS['GISStatus'] = GISStatus_toDict

