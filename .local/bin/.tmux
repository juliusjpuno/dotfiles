#!/usr/bin/env bash

TMUX_SESSION="scrapers"
TOTAL_WINDOWS=3
PANES_PER_WINDOW=8
START_INDEX=1

if tmux has-session -t "$SESSION" 2>/dev/null; then
    tmux new-session -d -s "$SESSION"
    echo "TMUX session '$SESSION' created and command started."
else
    echo "TMUX session '$SESSION' already exists."
fi

tmux send-keys :tmux-restore C-m

declare -a SSH_TARGETS=(
    # --- WINDOW 1 (Panes 1-8) ---
    "ssh -i ~/.ssh/deepci-main-kp -t root@deep-scraper-25 'tmux a -t crawly'" # Window 1, Pane 1
    "ssh -i ~/.ssh/deepci-main-kp -t root@deep-scraper-26 'tmux a -t crawly'" # Window 1, Pane 2
    "ssh -i ~/.ssh/deepci-main-kp -t root@deep-scraper-27 'tmux a -t crawly'" # Window 1, Pane 3
    "ssh -i ~/.ssh/deepci-main-kp -t root@deep-scraper-28 'tmux a -t crawly'" # Window 1, Pane 4
    "ssh -i ~/.ssh/deepci-main-kp -t root@deep-scraper-29 'tmux a -t crawly'" # Window 1, Pane 5
    "ssh -i ~/.ssh/deepci-main-kp -t root@deep-scraper-30 'tmux a -t crawly'" # Window 1, Pane 6
    "ssh -i ~/.ssh/deepci-main-kp -t root@deep-scraper-31 'tmux a -t crawly'" # Window 1, Pane 7
    "ssh -i ~/.ssh/deepci-main-kp -t root@deep-scraper-32 'tmux a -t crawly'" # Window 1, Pane 8

    # --- WINDOW 2 (Panes 1-8) ---
    "ssh -i ~/.ssh/deepci-main-kp -t root@deep-scraper-33 'tmux a -t crawly'" # Window 2, Pane 1
    "ssh -i ~/.ssh/deepci-main-kp -t root@deep-scraper-34 'tmux a -t crawly'" # Window 2, Pane 2
    "ssh -i ~/.ssh/deepci-main-kp -t root@deep-scraper-35 'tmux a -t crawly'" # Window 2, Pane 3
    "ssh -i ~/.ssh/deepci-main-kp -t root@deep-scraper-36 'tmux a -t crawly'" # Window 2, Pane 4
    "ssh -i ~/.ssh/deepci-main-kp -t root@deep-scraper-37 'tmux a -t crawly'" # Window 2, Pane 5
    "ssh -i ~/.ssh/deepci-main-kp -t root@deep-scraper-38 'tmux a -t crawly'" # Window 2, Pane 6
    "ssh -i ~/.ssh/deepci-main-kp -t root@deep-scraper-39 'tmux a -t crawly'" # Window 2, Pane 7
    "ssh -i ~/.ssh/deepci-main-kp -t root@deep-scraper-40 'tmux a -t crawly'" # Window 2, Pane 8

    # --- WINDOW 3 (Panes 1-8) ---
    "ssh -i ~/.ssh/deepci-main-kp -t root@deep-scraper-41 'tmux a -t crawly'" # Window 3, Pane 1
    "ssh -i ~/.ssh/deepci-main-kp -t root@deep-scraper-42 'tmux a -t crawly'" # Window 3, Pane 2
    "ssh -i ~/.ssh/deepci-main-kp -t root@deep-scraper-43 'tmux a -t crawly'" # Window 3, Pane 3
    "ssh -i ~/.ssh/deepci-main-kp -t root@deep-scraper-44 'tmux a -t crawly'" # Window 3, Pane 4
    "ssh -i ~/.ssh/deepci-main-kp -t root@deep-scraper-45 'tmux a -t crawly'" # Window 3, Pane 5
    "ssh -i ~/.ssh/deepci-main-kp -t root@deep-scraper-46 'tmux a -t crawly'" # Window 3, Pane 6
    "ssh -i ~/.ssh/deepci-main-kp -t root@deep-scraper-47 'tmux a -t crawly'" # Window 3, Pane 7
    "ssh -i ~/.ssh/deepci-main-kp -t root@deep-scraper-48 'tmux a -t crawly'" # Window 3, Pane 8
)
# ---------------------

echo "Disabling synchronize-panes for all windows"

for WINDOW_INDEX in $(seq $START_INDEX $((TOTAL_WINDOWS))); do
    TARGET_WINDOW="${TMUX_SESSION}:${WINDOW_INDEX}"
    tmux set-window-option -t "$TARGET_WINDOW" synchronize-panes off
done

echo "Starting SSH command distribution to 24 panes..."

# Counter for the SSH_TARGETS array index
TARGET_ARRAY_INDEX=0

# Loop through the windows (1 to 3)
for WINDOW_INDEX in $(seq $START_INDEX $((TOTAL_WINDOWS))); do

    # Loop through the panes in each window (1 to 8)
    for PANE_INDEX in $(seq $START_INDEX $((PANES_PER_WINDOW))); do

        # Construct the full tmux target ID: session:window.pane
        TARGET_PANE="${TMUX_SESSION}:${WINDOW_INDEX}.${PANE_INDEX}"
        SSH_COMMAND="${SSH_TARGETS[TARGET_ARRAY_INDEX]}"

        echo "  -> Window ${WINDOW_INDEX}, Pane ${PANE_INDEX} (${TARGET_ARRAY_INDEX}) with command: ${SSH_COMMAND}"

        # Execute the command in the target pane
        tmux send-keys -t "$TARGET_PANE" "$SSH_COMMAND" C-m

        # Increment the index for the SSH_TARGETS array
        TARGET_ARRAY_INDEX=$((TARGET_ARRAY_INDEX + 1))

    done
done

echo "Done. All 24 SSH commands sent."

echo "Re-enabling synchronize-panes for all windows..."

for WINDOW_INDEX in $(seq $START_INDEX $((TOTAL_WINDOWS))); do
    TARGET_WINDOW="${TMUX_SESSION}:${WINDOW_INDEX}"
    tmux set-window-option -t "$TARGET_WINDOW" synchronize-panes on
done
