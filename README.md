# Lab3_FAP201_IC2001
# Lab3_FAP201 – Edge Detection & LED Toggle

## Thông tin chung
- **Môn học:** FAP201 - FPGA Programming
- **Bài thực hành:** Lab03 - Edge Detection & Toggle LED (CLO1 & CLO2)
- **Mục tiêu:** Thiết kế, kiểm chứng và hiện thực mạch logic tuần tự phát hiện sườn tín hiệu (Edge Detection) để đảo trạng thái đèn LED (Toggle) mỗi khi nhả nút bấm trên bo mạch FPGA.

## Môi trường và Phần cứng
- **Công cụ phát triển:** Gowin EDA
- **Bo mạch (Board):** Xiaomeige ACG525
- **Chip FPGA (Target Device):** GW5A-LV25UG324C2/I1
- **Ngôn ngữ:** Verilog / VHDL (IEEE 1164 STD_LOGIC)[cite: 8, 9]

## Nguyên lý hoạt động & Phân tích Logic
- **Mạch logic tuần tự (Sequential Circuit):** 
  * Mạch sử dụng thanh ghi `r_Switch` để lưu lại trạng thái ngõ vào `i_Switch` ở chu kỳ xung nhịp trước đó[cite: 8, 9].
  * Phép so sánh `(i_Switch == 0 && r_Switch == 1)` đóng vai trò là mạch phát hiện sườn xuống (Falling Edge Detector / Nút bấm chuyển từ mức `1` sang `0`)[cite: 8, 9].
  * Khi phát hiện nút bấm vừa được nhả, trạng thái thanh ghi `r_LED` sẽ được đảo (`r_LED <= ~r_LED`)[cite: 8, 9].
- **Đồng bộ xung nhịp (Clock Synchronization):**
  * Tất cả chuyển mạch trạng thái diễn ra đồng bộ theo sườn dương của xung nhịp ngõ vào `i_Clk` (`posedge i_Clk` / `rising_edge(i_Clk)`)[cite: 8, 9].
  * Ràng buộc thời gian (SDC constraint) thiết lập chu kỳ xung nhịp là `20 ns` (tương đương tần số 50 MHz).

### Bảng trạng thái chuyển mạch (State Transition)
| i_Switch (Hiện tại) | r_Switch (Quá khứ) | Điều kiện phát hiện | Hành động `r_LED` | Trạng thái vật lý |
| :---: | :---: | :---: | :---: | :--- |
| `0` | `0` | Không đổi | Giữ nguyên | Nút đang giữ nguyên trạng thái thả |
| `1` | `0` | Sườn lên (`0` $\rightarrow$ `1`) | Giữ nguyên | Nhấn nút $\rightarrow$ Chưa đảo trạng thái LED |
| `1` | `1` | Không đổi | Giữ nguyên | Giữ nút bấm |
| `0` | `1` | **Sườn xuống (`1` $\rightarrow$ `0`)** | **`r_LED <= ~r_LED`** | **Nhả nút $\rightarrow$ LED ĐẢO TRẠNG THÁI (Bật/Tắt)**[cite: 8, 9, 10, 11] |

## Bảng ánh xạ chân vật lý & Timing Constraints

### Physical Constraints Mapping (`Lab3.cst`)
Tín hiệu được cấu hình trong file `Lab3.cst`:

| Tín hiệu Port | Chân FPGA | Linh kiện phần cứng | Cấu hình I/O (3.3V Bank VCCIO) |
| :--- | :---: | :--- | :--- |
| `i_Clk` | `T9` | System Clock (50 MHz) | `IO_TYPE=LVCMOS33`, `PULL_MODE=NONE` |
| `i_Switch` | `B16` | Switch / KEY0 | `IO_TYPE=LVCMOS33`, `PULL_MODE=NONE`[cite: 6] |
| `o_LED` | `D14` | Output LED / LED0 | `IO_TYPE=LVCMOS33`, `PULL_MODE=NONE`[cite: 6] |

### Timing Constraints (`Lab3.sdc`)
Ràng buộc thời gian được định nghĩa trong file `Lab3.sdc`[cite: 7]:
```tcl
create_clock -name i_Clk -period 20 -waveform {0 10} [get_ports {i_Clk}]
