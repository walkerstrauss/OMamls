let clear_lines num_lines =
  for _ = 1 to num_lines do
    print_string "\027[2K\027[1A"
    (* Clear line and move cursor up *)
    (* Move to the next line *)
  done

let clear_terminal () =
  let clear_command =
    match Sys.os_type with
    | "Unix" | "Cygwin" -> "clear" (* For Unix-like systems *)
    | "Win32" -> "cls" (* For Windows *)
    | _ -> ""
  in
  let _ = Sys.command clear_command in
  ()
