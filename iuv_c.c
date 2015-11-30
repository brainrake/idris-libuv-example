#include "iuv_c.h"
#include "build/IUV.h"
#include <uv.h>
#include <idris_rts.h>

VM* vm;

uv_loop_t *loop;

double c_uptime() {
    double v;
    int result = uv_uptime(&v);
    return v;
}

void close_cb(uv_handle_t* handle) {
    free(handle);
}

void c_setTimeout_cb(uv_timer_t* timer, int status) {
    uv_timer_stop(timer);
    idris_setTimeout_cb(vm, timer->data);
    uv_close(timer, &close_cb);
}

void c_setTimeout(int ms, void* cb) {
  uv_timer_t* timer = malloc(sizeof(uv_loop_t));
  timer->data = cb;
  uv_timer_init(loop, timer);
  uv_timer_start(timer, (uv_timer_cb) &c_setTimeout_cb, ms, ms);
}


void main() {
    vm = idris_vm();
    loop = malloc(sizeof(uv_loop_t));
    uv_loop_init(loop);

    idris_main(vm);

    uv_run(loop, UV_RUN_DEFAULT);

    uv_loop_close(loop);
    free(loop);

    close_vm(vm);
}
