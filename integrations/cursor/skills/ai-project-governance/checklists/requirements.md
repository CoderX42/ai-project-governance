# Requirements Analysis Checklist

Run `/requirements-analysis` when the user has a new idea or wants to clarify a new feature requirement.

## Phase 1: Detect Context

- [ ] Determine if this is a **new project** or an **enhancement to an existing project**
- [ ] If existing project: read the five root docs to understand current architecture before proceeding
- [ ] Check if `docs/项目需求分析.md` already exists
  - If yes: load it, identify which sections are incomplete or TODO
  - If no: create from template, focus on Section 1 first

## Phase 2: Explore the Idea

Engage the user in conversation to fill Section 1 and Section 2:

1. **Section 1 - 想法概述**: Ask them to describe the idea in their own words. Clarify vague terms. Summarize back and confirm understanding.
2. **Section 2 - 背景与动机**: Ask "为什么现在要做？" and "不做会怎样？" Probe for data or evidence, even if anecdotal.

If the user description is very short (< 3 sentences), use open-ended prompts to expand:
- 这个想法要解决什么问题？
- 现在怎么做的，理想情况应该是什么样的？
- 如果做成了，你会怎么判断它"成了"？

## Phase 3: Scope the Users and Scenarios

Fill Section 3 based on user input:

- Identify primary and secondary user roles
- Map the core user journey in 3-5 steps
- Note usage frequency and environment constraints

Ask: "谁会用？他们在什么情况下打开这个功能？打开后第一步做什么，最后一步做什么？"

## Phase 4: Feature Requirements

Fill Section 4 with the user, using progressive prioritization:

1. Ask: "如果只让你选一个功能先做，你选哪个？"
2. For each candidate feature, ask:
   - "这个功能上线后，用户怎么能感知到它生效了？"
   - "如果没有这个功能，整个事情还能成立吗？"
3. Classify each into P0 / P1 / P2
4. For P0 items, define concrete acceptance criteria

Ask the user to rank features in a spreadsheet-style table:
| 功能 | 描述 | P0/P1/P2 | 验收条件 |
If they struggle, propose a prioritization framework (MoSCoW or RICE).

## Phase 5: Non-Functional and Boundaries

Fill Section 5 and Section 6 in parallel:

- **Section 5 - 非功能性需求**: Ask about performance, security, compatibility, i18n, data persistence, logging.
- **Section 6 - 边界与排除**: Ask "这次不做什么？" If they cannot answer, propose likely exclusions (mobile support, admin panel, etc.) and confirm.

## Phase 6: Success Criteria and Open Issues

Fill Section 7 and Section 8:

- **Section 7**: Define what "done" means. Ask "这个功能怎么算成功？你会看什么指标？"
- **Section 8**: List known unknowns and risks. Ask "你觉得哪部分最难？哪里最不确定？"

## Phase 7: Resources and Final Review

Fill Section 9:

- Ask for any existing resources: prototypes, design files, competitor references, user research.
- Review the complete document with the user section by section.
- Confirm nothing critical was missed.

## Phase 8: Document the Requirement and Provide Next Steps

After the document is filled:

1. Save/update `docs/项目需求分析.md`
2. If the requirement is for an existing project:
   - Cross-check with `项目完整链路说明.md` and `项目文件结构说明.md`
   - Flag any compatibility issues or conflicts with existing architecture
   - Note them in Section 8
3. Provide next step recommendation:
   - If scope is clear and P0 is defined: "建议进入 /task-intake，从 P0 功能开始实现"
   - If open questions remain: "建议先解决以下问题再进入开发……"

## Output Format

End with:

```
Action: /requirements-analysis
Status: <complete / blocked / needs-user-input>
Next: <one-line next step>
Blocks: <list of open questions that prevent moving to implementation>
```