# Weekly Development Planning Template

## Week of: ___________

### Time Availability: 5 hours total

### Session Planning (1-2 hours each)
- **Session 1:** [ ] 2 hours
  - **Task:** 
  - **Status:** 

- **Session 2:** [ ] 2 hours
  - **Task:** 
  - **Status:** 

- **Session 3:** [ ] 1 hour
  - **Task:** 
  - **Status:** 

### GitHub Issues to Complete
- [ ] Issue #23 - Create .NET 8 API Project Structure
- [ ] Issue #24 - Set Up PostgreSQL Schema
- [ ] Issue #25 - Implement Basic JWT Authentication

### Weekly Goals
1. 
2. 
3. 

### Accomplishments
- 
- 
- 

### Blockers
- 
- 
- 

### Next Week Planning Notes
- 
- 
- 

---

## Session Tracking

### Session 1 - [Date/Time]
**Duration:** 2 hours
**Start Time:** 
**End Time:** 
**Task:** 
**Progress:** 
**Issues Closed:** 
**Notes:** 

### Session 2 - [Date/Time]
**Duration:** 2 hours
**Start Time:** 
**End Time:** 
**Task:** 
**Progress:** 
**Issues Closed:** 
**Notes:** 

### Session 3 - [Date/Time]
**Duration:** 1 hour
**Start Time:** 
**End Time:** 
**Task:** 
**Progress:** 
**Issues Closed:** 
**Notes:** 

---

## GitHub Automation Commands

### Update Issues
```bash
# Close completed issue
gh issue close <issue-number> --comment "Completed in <session-number> on <date>"

# Update issue status
gh issue edit <issue-number> --add-label "in-progress" --remove-label "todo"
```

### Create Session Notes
```bash
# Create new issue for session notes
gh issue create --title "Session Notes - Week <week-number>" --body "## Session Summary\n\n### Completed\n- \n\n### Blockers\n- \n\n### Learnings\n- "
```

---

## Time Management Tips

### Focus Strategies
1. **One task per session** - Avoid context switching
2. **Clear stopping point** - Know when to end each session
3. **Track time honestly** - Include setup and debugging time

### Efficiency Strategies
1. **Prepare before starting** - Know exactly what you'll work on
2. **Use timers** - 25-minute focused work blocks
3. **Document quickly** - Update GitHub immediately after changes

### Quality with Time Constraints
1. **Accept "good enough"** - Perfect is enemy of done
2. **Automate repetitive tasks** - Use scripts and tools
3. **Refactor later** - Keep momentum during sessions

## Sprint Review Template

### Sprint <Number> Review - [Date]

#### Completed Work
- [ ] Issue #23 - Create .NET 8 API Project Structure
- [ ] Issue #24 - Set Up PostgreSQL Schema  
- [ ] Issue #25 - Implement Basic JWT Authentication

#### Time Spent vs Planned
- **Planned:** 10 hours
- **Actual:** _____ hours
- **Variance:** _____ hours

#### What Went Well
- 
- 
- 

#### Challenges
- 
- 
- 

#### Improvements for Next Sprint
- 
- 
- 

#### Velocity Adjustment
- **Previous Velocity:** N/A
- **Current Velocity:** _____ points
- **Next Sprint Planning:** Adjust based on actuals