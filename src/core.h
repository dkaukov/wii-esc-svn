/**
 * Wii ESC NG 2.0 - 2012
 * HAL includes
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */


#if (BOARD == _BS_NFET_)
  #include "hal/m8.h"
  #include "hal/bs_nfet.h"
#endif

#if (BOARD == _BS_)
  #include "hal/m8.h"
  #include "hal/bs.h"
#endif

#if (BOARD == _TP_)
  #include "hal/m8.h"
  #include "hal/tp.h"
#endif

#if (BOARD == _TGY_)
  #include "hal/m8.h"
  #include "hal/tgy.h"
#endif

#if (BOARD == _TGY_16_)
  #include "hal/m8.h"
  #include "hal/tgy.h"
#endif
