#!/bin/bash

# BE-SAFE CyberDefense Matrix
# For Ubuntu 25.10 "Questing Quokka"
# Author: luisitsilva@flashintell.net
# Version: 2.0 - "BE-SAFE tool"

# Color codes for cool terminal effects
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
DARK_GRAY='\033[1;30m'
BLINK='\033[5m'
BOLD='\033[1m'
NC='\033[0m' # No Color


# ASCII Art Banner
show_banner() {
    clear
    echo -e "${RED}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║  ██████╗ ███████╗     ███████╗ █████╗ ███████╗███████╗      ║"
    echo "║  ██╔══██╗██╔════╝     ██╔════╝██╔══██╗██╔════╝██╔════╝      ║"
    echo "║  ██████╔╝█████╗       █████╗  ███████║█████╗  █████╗        ║"
    echo "║  ██╔══██╗██╔══╝       ██╔══╝  ██╔══██║██╔══╝  ██╔══╝        ║"
    echo "║  ██████╔╝███████╗     ███████╗██║  ██║██║     ███████╗      ║"
    echo "║  ╚═════╝ ╚══════╝     ╚══════╝╚═╝  ╚═╝╚═╝     ╚══════╝      ║"
    echo "=================================================="
    echo "   BE-SAFE on Ubuntu 25.10 - Questing Quokka"
    echo "   BE-SAFE Multi-Layer Defense System v2.0"
    echo "   by flashintell.net"
    echo "=================================================="
    LAST_SCAN=$(ls -t /var/log/super-scan-*.log 2>/dev/null | head -1 | xargs basename)
    echo "⚡ System Uptime: $(uptime -p | sed 's/up //')"
    check_and_install_tools
    echo "📊 Last Scan: ${LAST_SCAN:-Never}"
    echo ""
}

# Enhanced function with version checking
check_and_install_tools() {
    local MISSING_TOOLS=()
    local TOOLS=("rkhunter" "clamav" "chkrootkit" "lynis" "fail2ban-client")
    local TOOL_NAMES=("rkhunter" "ClamAV" "chkrootkit" "Lynis" "Fail2ban")
    local TOOL_PACKAGES=("rkhunter" "clamav" "chkrootkit" "lynis" "fail2ban")
    
    echo -e "\n${BOLD}${CYAN}═════════════════ TOOL VERIFICATION ═════════════════${NC}"
    
    # Check each tool
    for i in "${!TOOLS[@]}"; do
        printf "   %-12s" "${TOOL_NAMES[$i]}"
        
        if [ "${TOOLS[$i]}" = "clamav" ]; then
            # Special check for ClamAV (freshclam)
            if command -v freshclam &> /dev/null; then
                VERSION=$(freshclam --version 2>/dev/null | head -1 | cut -d' ' -f4)
                echo -e "${GREEN}✓ Installed${NC} ${DARK_GRAY}(v$VERSION)${NC}"
            else
                echo -e "${RED}✗ Missing${NC}"
                MISSING_TOOLS+=("${TOOL_PACKAGES[$i]}")
            fi
        else
            if command -v "${TOOLS[$i]}" &> /dev/null; then
                VERSION=$("${TOOLS[$i]}" --version 2>/dev/null | head -1 | cut -d' ' -f2- | cut -c1-10)
                echo -e "${GREEN}✓ Installed${NC} ${DARK_GRAY}($VERSION)${NC}"
            else
                echo -e "${RED}✗ Missing${NC}"
                MISSING_TOOLS+=("${TOOL_PACKAGES[$i]}")
            fi
        fi
    done
    
    # If tools are missing, ask to install
    if [ ${#MISSING_TOOLS[@]} -gt 0 ]; then
        echo -e "\n${BOLD}${YELLOW}⚠️  MISSING COMPONENTS DETECTED${NC}"
        echo -e "${YELLOW}The following security tools are not installed:${NC}"
        
        for tool in "${MISSING_TOOLS[@]}"; do
            case $tool in
                "rkhunter")    echo "   • rkhunter     - Rootkit detection and system analysis" ;;
                "clamav")      echo "   • clamav       - Antivirus engine for malware detection" ;;
                "chkrootkit")  echo "   • chkrootkit   - Local rootkit detection tool" ;;
                "lynis")       echo "   • lynis        - Security auditing and hardening tool" ;;
                "fail2ban")    echo "   • fail2ban     - Intrusion prevention framework" ;;
            esac
        done
        
        echo ""
        echo -ne "${BOLD}🛡️  Install missing components now? (y/n): ${NC}"
        read -r INSTALL_CHOICE
        
        if [[ "$INSTALL_CHOICE" =~ ^[Yy]$ ]]; then
            echo -e "\n${CYAN}▶ Updating package repositories...${NC}"
            sudo apt update -qq
            
            echo -e "${CYAN}▶ Installing: ${MISSING_TOOLS[*]}${NC}"
            sudo apt install -y "${MISSING_TOOLS[@]}" > /dev/null 2>&1
            
            # Special handling for ClamAV
            if [[ " ${MISSING_TOOLS[@]} " =~ " clamav " ]]; then
                echo -e "${CYAN}▶ Initializing ClamAV signature database...${NC}"
                sudo freshclam > /dev/null 2>&1 &
                echo -e "${GREEN}   ClamAV update started in background${NC}"
            fi
            
            echo -e "\n${GREEN}✅ All components installed successfully!${NC}"
            sleep 2
        else
            echo -e "\n${RED}⚠️  BE-SAFE will run with limited functionality${NC}"
            echo -e "${YELLOW}Install missing tools later with: sudo apt install ${MISSING_TOOLS[*]}${NC}"
            sleep 3
        fi
    else
        echo -e "\n${GREEN}✅ ALL SYSTEMS NOMINAL - Full BE-SAFE capability ready${NC}"
        sleep 1
    fi
    echo -e "${BOLD}${CYAN}════════════════════════════════════════════════════${NC}"
}

# Show menu options with cool formatting
show_menu() {
    echo -e "${BOLD}${CYAN}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${BOLD}${YELLOW}   🎯 MAIN DEFENSE MATRIX CONTROLS${NC}"
    echo -e "${BOLD}${CYAN}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${WHITE}  [${GREEN}1${WHITE}] ${BLUE}►${NC} ${BOLD}EXECUTE FULL SPECTRUM SCAN${NC}     ${DARK_GRAY}(All weapons hot)${NC}"
    echo -e "${WHITE}  [${GREEN}2${WHITE}] ${BLUE}►${NC} ${BOLD}Rapid Response Scan${NC}            ${DARK_GRAY}(Quick check - 2 min)${NC}"
    echo -e "${WHITE}  [${GREEN}3${WHITE}] ${BLUE}►${NC} ${BOLD}Deep File Integrity Scan${NC}       ${DARK_GRAY}(Tripwire style)${NC}"
    echo -e "${BOLD}${CYAN}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${BOLD}${YELLOW}   🔧 WEAPON SYSTEMS UPGRADE${NC}"
    echo -e "${BOLD}${CYAN}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${WHITE}  [${GREEN}4${WHITE}] ${BLUE}►${NC} ${BOLD}Update All Security Databases${NC}   ${DARK_GRAY}(Armor piercing rounds)${NC}"
    echo -e "${WHITE}  [${GREEN}5${WHITE}] ${BLUE}►${NC} ${BOLD}Rebuild Baseline (rkhunter --propupd)${NC}"
    echo -e "${WHITE}  [${GREEN}6${WHITE}] ${BLUE}►${NC} ${BOLD}Update ClamAV Signatures${NC}        ${DARK_GRAY}(Fresh blood)${NC}"
    echo -e "${BOLD}${CYAN}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${BOLD}${YELLOW}   📊 SURVEILLANCE & INTELLIGENCE${NC}"
    echo -e "${BOLD}${CYAN}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${WHITE}  [${GREEN}7${WHITE}] ${BLUE}►${NC} ${BOLD}View Last Scan Report${NC}          ${DARK_GRAY}(After action)${NC}"
    echo -e "${WHITE}  [${GREEN}8${WHITE}] ${BLUE}►${NC} ${BOLD}Live Security Log Feed${NC}          ${DARK_GRAY}(Real-time intel)${NC}"
    echo -e "${WHITE}  [${GREEN}9${WHITE}] ${BLUE}►${NC} ${BOLD}Show Threat Dashboard${NC}           ${DARK_GRAY}(System vitals)${NC}"
    echo -e "${WHITE}  [${GREEN}10${WHITE}]${BLUE}►${NC} ${BOLD}Fail2ban Prison Status${NC}         ${DARK_GRAY}(Blocked IPs)${NC}"
    echo -e "${BOLD}${CYAN}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${WHITE}  [${RED}0${WHITE}] ${RED}◄${NC} ${BOLD}EXIT DEFENSE MATRIX${NC}               ${DARK_GRAY}(Stand down)${NC}"
    echo -e "${BOLD}${CYAN}═══════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo -e "${YELLOW}Enter your command [0-10]:${NC} "
}

# Animation for scanning
scanning_animation() {
    local tool=$1
    echo -ne "${CYAN}[${GREEN}⚡${CYAN}]${NC} ${BOLD}Activating ${WHITE}$tool${NC} "
    for i in {1..5}; do
        echo -ne "${GREEN}.${NC}"
        sleep 0.3
    done
    echo -e "${GREEN} READY${NC}"
}

# Function: Full Spectrum Scan (Option 1)
full_spectrum_scan() {
    clear
    echo -e "${BOLD}${RED}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║🔥 BE-SAFE FULL SPECTRUM SCAN INITIATED - ALL WEAPONS HOT 🔥  ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    LOGFILE="/var/log/super-scan-$(date +%Y%m%d-%H%M%S).log"
    echo "SCAN STARTED: $(date)" | tee -a "$LOGFILE"
    echo "=========================================" | tee -a "$LOGFILE"
    
    # Phase 1: Update everything
    echo -e "\n${YELLOW}[PHASE 1/5]${NC} Armor Piercing Rounds - Updating Databases..."
    scanning_animation "Global Signature Network"
    
    echo -e "\n${CYAN}▶ Updating rkhunter signatures...${NC}"
    rkhunter --versioncheck --nocolors >> "$LOGFILE" 2>&1
    rkhunter --update --nocolors >> "$LOGFILE" 2>&1
    echo -e "${GREEN}✓ rkhunter updated${NC}"
    
    echo -e "${CYAN}▶ Updating ClamAV...${NC}"
    freshclam >> "$LOGFILE" 2>&1
    echo -e "${GREEN}✓ ClamAV updated${NC}"
    
    # Phase 2: rkhunter deep scan
    echo -e "\n${YELLOW}[PHASE 2/5]${NC} Deploying rkhunter - Deep Heuristic Analysis..."
    scanning_animation "Rootkit Hunter"
    echo -e "${CYAN}▶ Scanning for rootkits, anomalies, and hidden threats...${NC}"
    rkhunter --check --skip-keypress --enable all --disable none --nocolors >> "$LOGFILE" 2>&1
    RKH_STATUS=$?
    echo -e "${GREEN}✓ rkhunter scan complete${NC}"
    
    # Phase 3: chkrootkit
    echo -e "\n${YELLOW}[PHASE 3/5]${NC} Deploying chkrootkit - Legacy Rootkit Detection..."
    scanning_animation "CHKRootKit"
    chkrootkit -q >> "$LOGFILE" 2>&1
    echo -e "${GREEN}✓ chkrootkit scan complete${NC}"
    
    # Phase 4: ClamAV
    echo -e "\n${YELLOW}[PHASE 4/5]${NC} Deploying ClamAV - Malware/Virus Sweep..."
    scanning_animation "ClamAV"
    echo -e "${CYAN}▶ This may take a while... (Scanning filesystem)${NC}"
    clamscan -r / --exclude-dir=/proc --exclude-dir=/sys --exclude-dir=/dev --quiet >> "$LOGFILE" 2>&1
    echo -e "${GREEN}✓ ClamAV scan complete${NC}"
    
    # Phase 5: Lynis system audit
    echo -e "\n${YELLOW}[PHASE 5/5]${NC} Running Lynis - System Hardening Audit..."
    scanning_animation "Lynis"
    lynis audit system --quiet >> "$LOGFILE" 2>&1
    echo -e "${GREEN}✓ Lynis audit complete${NC}"
    
    # Summary
    echo -e "\n${BOLD}${GREEN}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${BOLD}${GREEN}  ✅ FULL SPECTRUM SCAN COMPLETE!${NC}"
    echo -e "${BOLD}${GREEN}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${WHITE}📁 Detailed log saved to: ${CYAN}$LOGFILE${NC}"
    echo -e "${WHITE}⚠️  Scan warnings (if any):${NC}"
    grep -i -E "warning|infected|suspicious|vulnerability" "$LOGFILE" | tail -10 | sed 's/^/   /'
    echo ""
    echo -e "${YELLOW}Press Enter to return to main menu...${NC}"
    read
}

# Function: Rapid Response Scan (Option 2)
rapid_response_scan() {
    clear
    echo -e "${BOLD}${CYAN}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║   ⚡ BE-SAFE RAPID RESPONSE SCAN - Quick Threat Sweep ⚡     ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    LOGFILE="/var/log/rapid-scan-$(date +%Y%m%d-%H%M%S).log"
    
    # Quick rkhunter scan
    echo -e "${CYAN}▶ Quick rkhunter scan...${NC}"
    rkhunter --check --skip-keypress --report-warnings-only --nocolors >> "$LOGFILE" 2>&1
    echo -e "${GREEN}✓ Complete${NC}"
    
    # Quick chkrootkit
    echo -e "${CYAN}▶ Quick chkrootkit scan...${NC}"
    chkrootkit -q >> "$LOGFILE" 2>&1
    echo -e "${GREEN}✓ Complete${NC}"
    
    # Show results
    echo -e "\n${YELLOW}Rapid Scan Results (Warnings only):${NC}"
    grep -i "warning" "$LOGFILE" 2>/dev/null | head -5 || echo -e "${GREEN}No immediate threats detected${NC}"
    
    echo -e "\n${YELLOW}Press Enter to continue...${NC}"
    read
}

# Function: Deep File Integrity (Option 3)
deep_integrity_scan() {
    clear
    echo -e "${BOLD}${PURPLE}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║ 🔍 BE-SAFE DEEP FILE INTEGRITY SCAN - Tripwire Style         ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    echo -e "${CYAN}▶ Running rkhunter file property check...${NC}"
    rkhunter --check --skip-keypress --enable all --disable none --nocolors | grep -i changed
    
    echo -e "\n${CYAN}▶ Checking critical system files...${NC}"
    sudo debsums -s 2>/dev/null | head -20 || echo -e "${GREEN}No modified package files found${NC}"
    
    echo -e "\n${YELLOW}Press Enter to continue...${NC}"
    read
}

# Function: Update All (Option 4)
update_all_databases() {
    clear
    echo -e "${BOLD}${GREEN}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║ 🔧 BE-SAFE UPDATING ALL SECURITY DATABASES - ARMING UP       ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    echo -e "${CYAN}▶ Updating rkhunter signatures...${NC}"
    rkhunter --versioncheck
    rkhunter --update
    
    echo -e "\n${CYAN}▶ Updating ClamAV signatures...${NC}"
    sudo freshclam
    
    echo -e "\n${CYAN}▶ Updating APT package lists...${NC}"
    sudo apt update
    
    echo -e "\n${GREEN}✅ All databases updated!${NC}"
    echo -e "\n${YELLOW}Press Enter to continue...${NC}"
    read
}

# Function: View Last Scan Report (Option 7)
view_last_report() {
    clear
    echo -e "${BOLD}${BLUE}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║ 📊 BE-SAFE LAST SCAN REPORT - AFTER ACTION INTELLIGENCE      ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    LAST_SCAN=$(ls -t /var/log/super-scan-*.log 2>/dev/null | head -1)
    
    if [ -f "$LAST_SCAN" ]; then
        echo -e "${CYAN}📁 Most recent scan: $(basename "$LAST_SCAN")${NC}\n"
        echo -e "${YELLOW}═══════════════ WARNINGS ═══════════════${NC}"
        grep -i -E "warning|infected|suspicious|vulnerability" "$LAST_SCAN" | tail -20 | \
            sed -e "s/\(.*warning.*\)/${RED}\1${NC}/i" \
                -e "s/\(.*infected.*\)/${RED}\1${NC}/i" \
                -e "s/\(.*vulnerability.*\)/${YELLOW}\1${NC}/i"
        
        echo -e "\n${YELLOW}═══════════════ FULL LOG INFO ═══════════════${NC}"
        echo -e "Total lines: $(wc -l < "$LAST_SCAN") | Size: $(du -h "$LAST_SCAN" | cut -f1)"
        echo -e "Scan started: $(head -1 "$LAST_SCAN")"
    else
        echo -e "${RED}No scan logs found. Run a full spectrum scan first (Option 1).${NC}"
    fi
    
    echo -e "\n${YELLOW}Press Enter to continue...${NC}"
    read
}

# Function: Live Security Log Feed (Option 8)
live_log_feed() {
    clear
    echo -e "${BOLD}${CYAN}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║ 📡 BE-SAFE LIVE SECURITY INTELLIGENCE FEED - CTRL+C TO EXIT  ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    echo -e "${YELLOW}Tailing security logs (fail2ban, auth, rkhunter)...${NC}\n"
    sudo tail -f /var/log/fail2ban.log /var/log/auth.log /var/log/rkhunter.log 2>/dev/null | \
        while IFS= read -r line; do
            if echo "$line" | grep -i "ban\|fail\|error" >/dev/null; then
                echo -e "${RED}$line${NC}"
            elif echo "$line" | grep -i "warning" >/dev/null; then
                echo -e "${YELLOW}$line${NC}"
            else
                echo -e "${GREEN}$line${NC}"
            fi
        done
}

# Function: Threat Dashboard (Option 9)
threat_dashboard() {
    clear
    echo -e "${BOLD}${PURPLE}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║              📈 BE-SAFE DASHBOARD - SYSTEM VITALS      ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    # CPU/Memory
    echo -e "${CYAN}💻 SYSTEM RESOURCES${NC}"
    echo "──────────────────────────────────────"
    echo -e "CPU Load: $(uptime | awk -F'load average:' '{print $2}')"
    echo -e "Memory: $(free -h | grep Mem | awk '{print $3"/"$2}')"
    echo -e "Processes: $(ps aux | wc -l)"
    echo ""
    
    # Failed SSH attempts
    echo -e "${YELLOW}🔐 FAILED SSH ATTEMPTS (last 24h)${NC}"
    echo "──────────────────────────────────────"
    sudo grep "Failed password" /var/log/auth.log | grep "$(date +%b\ %d)" | wc -l | xargs echo "Attempts:"
    
    # Fail2ban status
    echo -e "\n${RED}🚫 FAIL2BAN - CURRENTLY BANNED IPS${NC}"
    echo "──────────────────────────────────────"
    sudo fail2ban-client status sshd 2>/dev/null | grep "Banned IP list" | cut -d':' -f2- | sed 's/, /\n/g' | \
        awk '{print "   → " $0}' || echo "   No banned IPs"
    
    # Open ports
    echo -e "\n${GREEN}🔌 OPEN NETWORK PORTS${NC}"
    echo "──────────────────────────────────────"
    sudo ss -tulpn | grep LISTEN | awk '{print "   " $1 " " $5}' | head -5
    
    # Last rkhunter warnings
    echo -e "\n${YELLOW}⚠️  RECENT RKHUNTER WARNINGS${NC}"
    echo "──────────────────────────────────────"
    sudo grep Warning /var/log/rkhunter.log 2>/dev/null | tail -3 | sed 's/^/   /' || echo "   No recent warnings"
    
    echo -e "\n${YELLOW}Press Enter to return to menu...${NC}"
    read
}

# Function: Fail2ban Prison Status (Option 10)
fail2ban_status() {
    clear
    echo -e "${BOLD}${RED}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║              🔒 FAIL2BAN PRISON STATUS - BLOCKED HOSTS      ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    echo -e "${CYAN}Active Jails:${NC}"
    sudo fail2ban-client status | grep "Jail list" | cut -d':' -f2- | sed 's/,/\n/g' | sed 's/^/   → /'
    
    echo -e "\n${YELLOW}SSH Jail Details:${NC}"
    sudo fail2ban-client status sshd 2>/dev/null || echo "   SSH jail not enabled"
    
    echo -e "\n${GREEN}Recent bans (last 24h):${NC}"
    sudo grep Ban /var/log/fail2ban.log | grep "$(date +%Y-%m-%d)" | tail -5 | sed 's/^/   /'
    
    echo -e "\n${YELLOW}Options:${NC}"
    echo "   [u] Unban an IP"
    echo "   [m] Return to main menu"
    echo -n "Choice: "
    read choice
    if [ "$choice" = "u" ]; then
        echo -n "Enter IP to unban: "
        read ip
        sudo fail2ban-client set sshd unbanip "$ip"
        echo -e "${GREEN}IP $ip unbanned${NC}"
        sleep 2
    fi
}

# Main program loop
while true; do
    show_banner
    show_menu
    read choice
    
    case $choice in
        1)
            full_spectrum_scan
            ;;
        2)
            rapid_response_scan
            ;;
        3)
            deep_integrity_scan
            ;;
        4)
            update_all_databases
            ;;
        5)
            clear
            echo -e "${CYAN}▶ Rebuilding rkhunter baseline...${NC}"
            sudo rkhunter --propupd
            echo -e "${GREEN}✅ Baseline updated!${NC}"
            sleep 2
            ;;
        6)
            clear
            echo -e "${CYAN}▶ Updating ClamAV signatures...${NC}"
            sudo freshclam
            echo -e "${GREEN}✅ ClamAV updated!${NC}"
            sleep 2
            ;;
        7)
            view_last_report
            ;;
        8)
            live_log_feed
            ;;
        9)
            threat_dashboard
            ;;
        10)
            fail2ban_status
            ;;
        0)
            echo -e "\n${GREEN}🛡️  BE-SAFE tool. Stay secure!${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid option. Press Enter to continue...${NC}"
            read
            ;;
    esac
done
