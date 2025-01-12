       >>SOURCE FORMAT IS FREE
*>*******************************************
*> testing fastcgi from cobol
*>*******************************************
identification division.
program-id. echo.

environment division.
configuration section.
repository.
    function all intrinsic.

input-output section.

data division.

working-storage section.

01  rc usage binary-long value 0.
01  rc-cbl pic s9(8).

01  out-str pic x(100).

01  in-handle          usage pointer.
01  out-handle         usage pointer.
01  err-handle         usage pointer.
01  fcgx-envp          usage pointer.

01  temp pic x(100).
01  ptr usage pointer.

01  j PIC 9(4).
01  outchar pic x.
01  outint usage binary-int.

01  request-uri pic x based.
01  request-uri-ptr usage pointer.

procedure division.

mainline.
    call "FCGX_Accept"
    using
        by reference in-handle
        by reference out-handle
        by reference err-handle
        by reference fcgx-envp
    returning rc
    end-call

    perform until rc is less than zero
        call 'FCGX_GetParam'
        using
            by content 'REQUEST_URI'
            by value fcgx-envp
        returning request-uri-ptr

        move 'Content-type: text/plain' to out-str
        perform send-str

        move spaces to out-str
        perform send-str

        move 'hello world' to out-str
        perform send-str

        move null to in-handle out-handle err-handle
        call "FCGX_Accept"
        using
            by reference in-handle
            by reference out-handle
            by reference err-handle
            by reference fcgx-envp
        returning rc
        on exception
            move -1 to rc
        end-call
    end-perform

    goback.

send-str section.
    call "FCGX_FPrintF"
    using
        by value out-handle
        by content '%s'
        by content concatenate(trim(out-str), x'0d', x'0a', x'00')
    returning rc
    end-call.
