RAM Modules in Verilog (Single-Port and 4-Port Shared)

This project implements both single-port and multi-port RAM modules using Verilog HDL. It is designed primarily for educational purposes and serves as a demonstration of memory modeling, access arbitration, and basic data integrity in digital hardware systems. The two modules illustrate how synchronous memory operations are handled in both isolated and shared environments.

The single-port RAM supports 1024 memory locations, each 8 bits wide. It features synchronous write and asynchronous read capabilities. A dedicated testbench writes sequential data to all locations, then performs a series of random reads using a reproducible seed. This helps validate proper memory storage and access behavior under simulation.

The 4-port shared RAM module allows simultaneous access from four independent ports (A, B, C, D). To prevent write collisions, it implements a write-priority mechanism where Port A has the highest priority, followed by Ports B, C, and D. If multiple ports attempt to write to the same address in the same clock cycle, only the highest-priority port succeeds. Additionally, the module includes a conflict detection feature, which raises a signal when such write conflicts occur. The corresponding testbench simulates normal and conflicting conditions and verifies both correct memory writes and the triggering of the conflict signal.

Key components include the shared memory array, port-specific control logic, priority resolution mechanism, and conflict detection logic. Each module is self-contained and has been tested with simulation output verified through both console outputs.

This project is ideal for beginners learning Verilog memory design, conflict management, and testbench-driven verification. It also lays the groundwork for more advanced topics like cache controllers, dual-port RAMs, and memory-mapped peripheral systems.

Future enhancements could include pipelined memory access, dual-clock support, support for wider data buses, and integration with CPU datapaths. Contributions, testing with different simulators, and expansion toward real-world deployment are encouraged.
