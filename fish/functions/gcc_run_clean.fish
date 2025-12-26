function gcc_run_clean --description '带 -Wall -std=gnu11 -g 参数的gcc编译并运行'
    # 检查参数数量。必须至少传入一个源文件名
    if test (count $argv) -lt 1
        echo "用法：gcc_run_clean <源文件名.c> [程序运行参数...]" | lolcat
        return 1
    end

    # ----------------------------------------------------
    # 1. 准备阶段
    # ----------------------------------------------------
    set source_file $argv[1]
    # 自动生成输出文件名 (如：test.c -> test)
    set output_file (basename $source_file .c)

    # 捕获 C 程序的运行参数：从 $argv 的第二个元素到最后一个元素
    set program_args $argv[2..-1]

    # ----------------------------------------------------
    # 2. 编译阶段
    # ----------------------------------------------------
    echo "--- 编译：$source_file ---"
    # 使用安全的 list 结构来构建命令
    set compile_cmd gcc -Wall -g -std=gnu11 $source_file -o $output_file -D_GNU_SOURCE -lrt -lm

    # 直接执行命令（在 Fish 中，直接运行变量列表是安全的）
    $compile_cmd

    # 检查编译是否成功
    if test $status -ne 0
        echo "--- 编译失败，停止执行 ---" | lolcat
        return 1
    end

    # ----------------------------------------------------
    # 3. 运行阶段
    # ----------------------------------------------------
    # 将输出文件名和程序参数连接起来，形成完整的运行命令
    echo "--- 运行：./$output_file $program_args ---"

    # 运行程序并传递所有参数。Fish 会正确地处理 $program_args 列表
    ./$output_file $program_args
    set run_status $status

    # ----------------------------------------------------
    # 4. 清理阶段
    # ----------------------------------------------------
    if test -e $output_file
        echo "--- 清理：删除 $output_file ---"
        rm $output_file
    end

    return $run_status
end
